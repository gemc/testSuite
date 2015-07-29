{
	string which[2] = {"master", "branch"};
	double landauConst[2];
	double landauMPV[2];
	double landauSigma[2];
	TH1F *edep[2];
	TFile *f[2];
	
	TCanvas *ftofC = new TCanvas("ftofC", "ftofC", 800, 800);

	for(int w=0; w<2; w++)
	{
		f[w] = new TFile(Form("ftof%s.root", which[w].c_str()));

		string hTit = Form("edep%s", which[w].c_str());
		edep[w] = new TH1F(hTit.c_str(), hTit.c_str(), 100, 5, 20);

		string plot = Form("totEdep>>%s", hTit.c_str());
		ftof_p1a->Draw(plot.c_str());
		
		edep[w]->Fit("landau");

		
		landauConst[w] = edep[w]->GetFunction("landau")->GetParameter(0);
		landauMPV[w]   = edep[w]->GetFunction("landau")->GetParameter(1);
		landauSigma[w] = edep[w]->GetFunction("landau")->GetParameter(2);
	}
	
	double diffConstant = 100*(landauConst[1] - landauConst[0])/landauConst[0];
	double diffMPV      = 100*(  landauMPV[1] -   landauMPV[0])/  landauMPV[0];
	double diffSigma    = 100*(landauSigma[1] - landauSigma[0])/landauSigma[0];
	
	cout << "  > Edep Landau Constant percentage difference: " << diffConstant << " %" << endl;
	cout << "  > Edep Landau MPV percentage difference: "      << diffMPV      << " %" << endl;
	cout << "  > Edep Landau Sigma percentage difference: "    << diffSigma    << " %" << endl;
	
	f[0]->cd();
	edep[0]->SetLineColor(kBlue);
	edep[0]->GetFunction("landau")->SetLineColor(kBlue);
	edep[0]->Draw();
	f[1]->cd();
	edep[1]->SetLineColor(kRed);
	edep[1]->GetFunction("landau")->SetLineColor(kRed);
	edep[1]->Draw("same");

	TLatex lab;
	lab.SetNDC();
	lab.SetTextColor(kBlack);
	lab.SetTextSize(0.030);
	
	lab.DrawLatex(0.50, 0.70,  Form("const: %4.3f (%4.3f)", landauConst[1], landauConst[0]));
	lab.DrawLatex(0.50, 0.65,  Form("mean:  %4.3f (%4.3f)",   landauMPV[1],   landauMPV[0]));
	lab.DrawLatex(0.50, 0.60,  Form("sigma: %4.3f (%4.3f)", landauSigma[1], landauSigma[0]));
	
	
	ftofC->Print("ftofTest.png");
}
