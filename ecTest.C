{
	double mom  = 5;       // 5 GeV initial momentum

	string which[2] = {"master", "branch"};
	double gausConst[2];
	double gausSF[2];
	double gausSigma[2];
	TH1F *edep[2];
	TFile *f[2];

	TCanvas *ecC = new TCanvas("ecC", "ecC", 800, 800);
	
	for(int w=0; w<2; w++)
	{
		f[w] = new TFile(Form("ec%s.root", which[w].c_str()));
		
		string hTit = Form("edep%s", which[w].c_str());
		edep[w] = new TH1F(hTit.c_str(), hTit.c_str(), 100, 0.1, 0.5);

		vector<double> *ecTotE = 0;

		TTree *ecT  = (TTree*)f[w]->Get("ec");
		ecT->SetBranchAddress("totEdep",     &ecTotE);

		for(int i=0; i<ecT->GetEntries(); i++)
		{
			ecT->GetEntry(i);
			double sampF = 0;
			
			for(unsigned d=0; d<(*ecTotE).size(); d++)
				sampF += (*ecTotE)[d] / mom / 1000;
			
			edep[w]->Fill(sampF);
			
		}
		
		edep[w]->Fit("gaus");
		edep[w]->GetXaxis()->SetRangeUser(0.2, 0.35);
		
		gausConst[w] = edep[w]->GetFunction("gaus")->GetParameter(0);
		gausSF[w]    = edep[w]->GetFunction("gaus")->GetParameter(1);
		gausSigma[w] = edep[w]->GetFunction("gaus")->GetParameter(2);
	}

	double diffConstant = 100*(gausConst[1] - gausConst[0])/gausConst[0];
	double diffSF       = 100*(   gausSF[1] -    gausSF[0])/   gausSF[0];
	double diffSigma    = 100*(gausSigma[1] - gausSigma[0])/gausSigma[0];

	cout << "  > Edep Sampling Fraction Constant percentage difference: " << diffConstant << " %" << endl;
	cout << "  > Edep Sampling Fraction MPV percentage difference: "      << diffSF       << " %" << endl;
	cout << "  > Edep Sampling Fraction Sigma percentage difference: "    << diffSigma    << " %" << endl;
	
	f[0]->cd();
	edep[0]->SetLineColor(kBlue);
	edep[0]->GetFunction("gaus")->SetLineColor(kBlue);
	edep[0]->Draw();
	f[1]->cd();
	edep[1]->SetLineColor(kRed);
	edep[1]->GetFunction("gaus")->SetLineColor(kRed);
	edep[1]->Draw("same");
	
	TLatex lab;
	lab.SetNDC();
	lab.SetTextColor(kBlack);
	lab.SetTextSize(0.030);

	lab.DrawLatex(0.60, 0.70,  Form("const: %4.3f (%4.3f)", gausConst[1], gausConst[0] ));
	lab.DrawLatex(0.60, 0.65,  Form("mean:  %4.3f (%4.3f)",    gausSF[1],    gausSF[0] ));
	lab.DrawLatex(0.60, 0.60,  Form("sigma: %4.3f (%4.3f)", gausSigma[1], gausSigma[0] ));
	
	ecC->Print("ecTest.png");
}
