#include "MyAnalysis.h"
#include "Plotter.h"
#include <iostream>
#include <TChain.h>
#include <TGraphAsymmErrors.h>
#include <string>

int main() {
   
   float lumi = 50.;
   cout<<"####################"<<endl;
   cout<<"Start of reading 'DATA'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *A = new MyAnalysis();
   TChain* ch = new TChain("events");
   ch->Add("files/data.root");
   ch->Process(A);
   cout<<"End  of reading 'DATA'"<<endl;   
   cout<<"####################"<<endl;


   cout<<"Start of reading 'TTbar'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *B = new MyAnalysis();
   TChain* ch2 = new TChain("events");
   ch2->Add("files/ttbar.root");
   ch2->Process(B);
   cout<<"End  of reading 'TTbar'"<<endl;   
   cout<<"####################"<<endl;  


   cout<<"Start of reading 'Wjets'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *C = new MyAnalysis();
   TChain* ch3 = new TChain("events");
   ch3->Add("files/wjets.root");
   ch3->Process(C);
   cout<<"End  of reading 'Wjets'"<<endl;   
   cout<<"####################"<<endl;  
 
   
   cout<<"Start of reading 'DY'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *D = new MyAnalysis();
   TChain* ch4 = new TChain("events");
   ch4->Add("files/dy.root");
   ch4->Process(D);
   cout<<"End  of reading 'DY'"<<endl;   
   cout<<"####################"<<endl;  

  
   cout<<"Start of reading 'WW'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *E = new MyAnalysis();
   TChain* ch5 = new TChain("events");
   ch5->Add("files/ww.root");
   ch5->Process(E);
   cout<<"End  of reading 'WW'"<<endl;   
   cout<<"####################"<<endl;  

 
   cout<<"Start of reading 'WZ'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *F = new MyAnalysis();
   TChain* ch6 = new TChain("events");
   ch6->Add("files/wz.root");
   ch6->Process(F);
   cout<<"End  of reading 'WZ'"<<endl;   
   cout<<"####################"<<endl;  

 
   cout<<"Start of reading 'ZZ'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *G = new MyAnalysis();
   TChain* ch7 = new TChain("events");
   ch7->Add("files/zz.root");
   ch7->Process(G);
   cout<<"End  of reading 'ZZ'"<<endl;   
   cout<<"####################"<<endl;  
 

   cout<<"Start of reading 'QCD'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *H = new MyAnalysis();
   TChain* ch8 = new TChain("events");
   ch8->Add("files/qcd.root");
   ch8->Process(H);
   cout<<"End  of reading 'QCD'"<<endl;   
   cout<<"####################"<<endl;  
 

   cout<<"Start of reading 'single Top'"<<endl;   
   cout<<"*********************"<<endl;
   MyAnalysis *I = new MyAnalysis();
   TChain* ch9 = new TChain("events");
   ch9->Add("files/single_top.root");
   ch9->Process(I);
   cout<<"End  of reading 'single Top'"<<endl;   
   cout<<"####################"<<endl;  
 

	Plotter P;
	P.SetData(A->histograms, std::string("Data"));
	P.AddBg(B->histograms, std::string("TTbar"));
	P.AddBg(C->histograms, std::string("Wjets"));
	P.AddBg(D->histograms, std::string("DY"));
	P.AddBg(E->histograms, std::string("WW"));
	P.AddBg(F->histograms, std::string("WZ"));
	P.AddBg(G->histograms, std::string("ZZ"));
	P.AddBg(H->histograms, std::string("QCD"));
	P.AddBg(I->histograms, std::string("single Top"));
   
	P.Plot(string("results.pdf"));
   
	Plotter P_MC;
	P_MC.AddBg(B->histograms_MC, std::string("TTbar"));
	P_MC.AddBg(C->histograms_MC, std::string("Wjets"));
	P_MC.AddBg(D->histograms_MC, std::string("DY"));
	P_MC.AddBg(E->histograms_MC, std::string("WW"));
	P_MC.AddBg(F->histograms_MC, std::string("WZ"));
	P_MC.AddBg(G->histograms_MC, std::string("ZZ"));
	P_MC.AddBg(H->histograms_MC, std::string("QCD"));
	P_MC.AddBg(I->histograms_MC, std::string("single Top"));
   P_MC.Plot(string("results_MC.pdf"));

}
