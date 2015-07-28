{
	
	// standad values
	double stdConstant = 1260;
	double stdMPV      = 9.49;   // most probably value
	double stdSigma    = 0.55;
	
	
	TCanvas *ftofC = new TCanvas("ftofC", "ftofC", 800, 800);
	
	TFile f("ftof.root");
	
	TH1F *edep = new TH1F("edep", "edep", 100, 5, 20);
	
	ftof_p1a->Draw("totEdep>>edep");
	
	edep->Fit("landau");
	
	
	double devConstant = edep->GetFunction("landau")->GetParameter(0);
	double devMPV      = edep->GetFunction("landau")->GetParameter(1);
	double devSigma    = edep->GetFunction("landau")->GetParameter(2);

	double diffConstant = 100*(devConstant - stdConstant)/stdConstant;
	double diffMPV      = 100*(devMPV - stdMPV)/stdMPV;
	double diffSigma    = 100*(devSigma - stdSigma)/stdSigma;
	
	cout << " FTOF Test: Edep Landau Constant percentage difference: " << diffConstant << " %" << endl;
	cout << " FTOF Test: Edep Landau MPV percentage difference: "      << diffMPV      << " %" << endl;
	cout << " FTOF Test: Edep Landau Sigma percentage difference: "    << diffSigma    << " %" << endl;
	
	TF1 *theo = new TF1("theo", "landau", 5, 20);
	
	theo->SetParameter(0, stdConstant);
	theo->SetParameter(1, stdMPV);
	theo->SetParameter(2, stdSigma);

	theo->SetLineColor(kBlue);
	theo->SetLineStyle(2);
	theo->Draw("same");
	
	TLatex lab;
	lab.SetNDC();
	lab.SetTextColor(kBlack);
	lab.SetTextSize(0.030);
	
	lab.DrawLatex(0.50, 0.70,  Form("const: %4.3f (%4.3f)", devConstant, stdConstant));
	lab.DrawLatex(0.50, 0.65,  Form("mean:  %4.3f (%4.3f)", devMPV,      stdMPV));
	lab.DrawLatex(0.50, 0.60,  Form("sigma: %4.3f (%4.3f)", devSigma,    stdSigma));
	
	
	ftofC->Print("ftofTest.png");
}
