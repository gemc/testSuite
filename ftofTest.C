{
	
	// standad values
	double stdConstant = 494;
	double stdMPV      = 9.47;   // most probably value
	double stdSigma    = 0.53;
	
	
	
	TFile f("ftof.root");
	
	TH1F *edep = new TH1F("edep", "edep", 100, 5, 20);
	
	ftof_p1a->Draw("totEdep>>edep");
	
	
	edep->Fit("landau");
	
	
	double devConstant = 100*(edep->GetFunction("landau")->GetParameter(0) - stdConstant)/stdConstant;
	double devMPV      = 100*(edep->GetFunction("landau")->GetParameter(1) - stdMPV)/stdMPV;
	double devSigma    = 100*(edep->GetFunction("landau")->GetParameter(2) - stdSigma)/stdSigma;

	
	cout << " FTOF Test: Edep Landau Constant percentage difference: " << devConstant << endl;
	cout << " FTOF Test: Edep Landau MPV percentage difference: "      << devMPV << endl;
	cout << " FTOF Test: Edep Landau Sigma percentage difference: "    << devSigma << endl;
	
}