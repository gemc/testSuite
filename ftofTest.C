{
	
	// standad values
	double stdConstant = 1260;
	double stdMPV      = 9.49;   // most probably value
	double stdSigma    = 0.55;
	
	
	
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

	
	cout << " FTOF Test: Edep Landau Constant percentage difference: " << diffConstant << "%" << endl;
	cout << " FTOF Test: Edep Landau MPV percentage difference: "      << diffMPV      << "%" << endl;
	cout << " FTOF Test: Edep Landau Sigma percentage difference: "    << diffSigma    << "%" << endl;
	
}