{
	
	string which[2] = {"master", "branch"};
	double gausConst[2];
	double gausMPV[2];
	double gausSigma[2];
	TH1F *edep[2];
	TF1 *landa[2];
	TFile *f[2];
	
	TCanvas *ecC = new TCanvas("ecC", "ecC", 800, 800);
	
	
	
	
	for(int w=0; w<2; w++)
	{
		f[w] = new TFile(Form("ec%s.root", which[w].c_str()));
		vector<double> *ecTotE = 0;

		
		string hTit = Form("edep%s", which[w].c_str());
		edep[w] = new TH1F(hTit.c_str(), hTit.c_str(), 100, 5, 20);
		
		landa[w] = new TF1(Form("land%s", which[w].c_str()), "landau", 5, 20);
		
		string plot = Form("totEdep>>%s", hTit.c_str());
		ftof_p1a->Draw(plot.c_str());
		
		edep[w]->Fit("landau");
		
		
		landauConst[w] = edep[w]->GetFunction("landau")->GetParameter(0);
		landauMPV[w]   = edep[w]->GetFunction("landau")->GetParameter(1);
		landauSigma[w] = edep[w]->GetFunction("landau")->GetParameter(2);
		
		landa[w] = new TF1(Form("land%s", which[w].c_str()), "landau", 5, 20);
		landa[w]->SetParameter(0, landauConst[w]);
		landa[w]->SetParameter(1, landauMPV[w]);
		landa[w]->SetParameter(2, landauSigma[w]);
		
	}
	

	
	
	
	
	
	
	
	
	
	// EC Hits

	TTree *ecT  = (TTree*)finp.Get("ec");
	ecT->SetBranchAddress("totEdep",     &ecTotE);

	for(int i=0; i<ecT->GetEntries(); i++)
	{
		ecT->GetEntry(i);
		double sampF = 0;
		
		for(unsigned d=0; d<(*ecTotE).size(); d++)
			sampF += (*ecTotE)[d] / mom / 1000;
		
		edep->Fill(sampF);
		
	}
	
	edep->Fit("gaus");
	edep->GetXaxis()->SetRangeUser(0.2, 0.35);
	
	
	double devConstant = edep->GetFunction("gaus")->GetParameter(0);
	double devSF       = edep->GetFunction("gaus")->GetParameter(1);
	double devSigma    = edep->GetFunction("gaus")->GetParameter(2);

	double diffConstant = 100*(devConstant - stdConstant)/stdConstant;
	double diffSF       = 100*(devSF - stdSF)/stdSF;
	double diffSigma    = 100*(devSigma - stdSigma)/stdSigma;

	cout << " EC Test: Edep Sampling Fraction Constant percentage difference: " << diffConstant << " %" << endl;
	cout << " EC Test: Edep Sampling Fraction MPV percentage difference: "      << diffSF       << " %" << endl;
	cout << " EC Test: Edep Sampling Fraction Sigma percentage difference: "    << diffSigma    << " %" << endl;

	
	TF1 *theo = new TF1("theo", "gaus", 0, 0.5);
	
	theo->SetParameter(0, stdConstant);
	theo->SetParameter(1, stdSF);
	theo->SetParameter(2, stdSigma);

	theo->SetLineColor(kBlue);
	theo->SetLineStyle(2);
	theo->Draw("same");
	
	TLatex lab;
	lab.SetNDC();
	lab.SetTextColor(kBlack);
	lab.SetTextSize(0.030);

	lab.DrawLatex(0.60, 0.70,  Form("const: %4.3f (%4.3f)", devConstant, stdConstant));
	lab.DrawLatex(0.60, 0.65,  Form("mean:  %4.3f (%4.3f)", devSF,       stdSF));
	lab.DrawLatex(0.60, 0.60,  Form("sigma: %4.3f (%4.3f)", devSigma,    stdSigma));
	
	ecC->Print("ecTest.png");
}
