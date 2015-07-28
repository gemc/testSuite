{
	
	// standad values
	double stdConstant = 6.13;
	double stdSF       = 0.157;   // sampling fraction
	double stdSigma    = 0.033;
	double mom         = 4;       // 5 GeV initial momentum
	
	TCanvas *pcalC = new TCanvas("pcalC", "pcalC", 800, 800);
	
	TFile finp("clas12.root");
	
	TH1F *edep = new TH1F("edep", "edep", 100, 0.0, 0.3);
	
	// pcal Hits
	vector<double> *pcalTotE = 0;

	TTree *pcalT  = (TTree*)finp.Get("pcal");
	pcalT->SetBranchAddress("totEdep",     &pcalTotE);

	for(int i=0; i<pcalT->GetEntries(); i++)
	{
		pcalT->GetEntry(i);
		double sampF = 0;
		
		for(unsigned d=0; d<(*pcalTotE).size(); d++)
			sampF += (*pcalTotE)[d] / mom / 1000;
		
		edep->Fill(sampF);
		
	}
	
	edep->Fit("gaus");
	//	edep->GetXaxis()->SetRangeUser(0.2, 0.35);
	
	
	double devConstant = edep->GetFunction("gaus")->GetParameter(0);
	double devSF       = edep->GetFunction("gaus")->GetParameter(1);
	double devSigma    = edep->GetFunction("gaus")->GetParameter(2);

	double diffConstant = 100*(devConstant - stdConstant)/stdConstant;
	double diffSF       = 100*(devSF - stdSF)/stdSF;
	double diffSigma    = 100*(devSigma - stdSigma)/stdSigma;

	cout << " pcal Test: Edep Sampling Fraction Constant percentage difference: " << diffConstant << " %" << endl;
	cout << " pcal Test: Edep Sampling Fraction MPV percentage difference: "      << diffSF       << " %" << endl;
	cout << " pcal Test: Edep Sampling Fraction Sigma percentage difference: "    << diffSigma    << " %" << endl;

	
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

	
	pcalC->Print("pcalTest.png");
	
	
}
