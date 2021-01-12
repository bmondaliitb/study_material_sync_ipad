#define MyAnalysis_cxx
// The class definition in MyAnalysis.h has been generated automatically
// by the ROOT utility TTree::MakeSelector(). This class is derived
// from the ROOT class TSelector. For more information on the TSelector
// framework see $ROOTSYS/README/README.SELECTOR or the ROOT User Manual.

// The following methods are defined in this file:
//    Begin():        called every time a loop on the tree starts,
//                    a convenient place to create your histograms.
//    SlaveBegin():   called after Begin(), when on PROOF called only on the
//                    slave servers.
//    Process():      called for each event, in this function you decide what
//                    to read and fill your histograms.
//    SlaveTerminate: called at the end of the loop on the tree, when on PROOF
//                    called only on the slave servers.
//    Terminate():    called at the end of the loop on the tree,
//                    a convenient place to draw/fit your histograms.
//
// To use this file, try the following session on your Tree T:
//
// Root > T->Process("MyAnalysis.C")
// Root > T->Process("MyAnalysis.C","some options")
// Root > T->Process("MyAnalysis.C+")
//

#include "MyAnalysis.h"
#include <iostream>
#include <TH1F.h>
#include <TLatex.h>
//#include<TLorentzVector.h>

using namespace std;

//adding Underflow function
//void addUnderflow(TH1 *h)
//{
//  UInt_t entries = h->GetEntries();
//  //add the underflow to the first bin
//  Double_t underflow = h->GetBinContent(0);
//  Double_t sum = h->GetBinContent(1) + underflow;
//  h->SetBinContent( 1, sum);
//  //set the underflow bin to zero
//  h->SetBinContent( 0, 0);
//  //restore the number of entries
//  h->SetEntries(entries);
//}



void MyAnalysis::BuildEvent() {
   
   Muons.clear();
   for (int i = 0; i < NMuon; ++i) {
      MyMuon muon(Muon_Px[i], Muon_Py[i], Muon_Pz[i], Muon_E[i]);
      muon.SetIsolation(Muon_Iso[i]);
      muon.SetCharge(Muon_Charge[i]);
      Muons.push_back(muon);
   }
   
   Electrons.clear();
   for (int i = 0; i < NElectron; ++i) {
      MyElectron electron(Electron_Px[i], Electron_Py[i], Electron_Pz[i], Electron_E[i]);
      electron.SetIsolation(Electron_Iso[i]);
      electron.SetCharge(Electron_Charge[i]);
      Electrons.push_back(electron);
   }
   
   Photons.clear();
   for (int i = 0; i < NPhoton; ++i) {
      MyPhoton photon(Photon_Px[i], Photon_Py[i], Photon_Pz[i], Photon_E[i]);
      photon.SetIsolation(Photon_Iso[i]);
      Photons.push_back(photon);
   }
   
   Jets.clear();
   for (int i = 0; i < NJet; ++i) {
      MyJet jet(Jet_Px[i], Jet_Py[i], Jet_Pz[i], Jet_E[i]);
      jet.SetBTagDiscriminator(Jet_btag[i]);
      jet.SetJetID(Jet_ID[i]);
      Jets.push_back(jet);
   }
   
   hadB.SetXYZM(MChadronicBottom_px, MChadronicBottom_py, MChadronicBottom_pz, 4.8);
   lepB.SetXYZM(MCleptonicBottom_px, MCleptonicBottom_py, MCleptonicBottom_pz, 4.8);
   hadWq.SetXYZM(MChadronicWDecayQuark_px, MChadronicWDecayQuark_py, MChadronicWDecayQuark_pz, 0.0);
   hadWqb.SetXYZM(MChadronicWDecayQuarkBar_px, MChadronicWDecayQuarkBar_py, MChadronicWDecayQuarkBar_pz, 0.0);
   lepWl.SetXYZM(MClepton_px, MClepton_py, MClepton_pz, 0.0);
   lepWn.SetXYZM(MCneutrino_px, MCneutrino_py, MCneutrino_pz, 0.0);
   met.SetXYZM(MET_px, MET_py, 0., 0.);
   
   EventWeight *= weight_factor;
   
   }

void MyAnalysis::Begin(TTree * /*tree*/) {
   // The Begin() function is called at the start of the query.
   // When running with PROOF Begin() is only called on the client.
   // The tree argument is deprecated (on PROOF 0 is passed).
   
   TString option = GetOption();
   
}

void MyAnalysis::SlaveBegin(TTree * /*tree*/) {
   // The SlaveBegin() function is called after the Begin() function.
   // When running with PROOF SlaveBegin() is called on each slave server.
   // The tree argument is deprecated (on PROOF 0 is passed).
   
   TString option = GetOption();
///////////////////////////////  
//   Generated/Truth histograms
//////////////////////////////
   //Pt of muons 
   h_Muon_Pt = new TH1F("Muon_Pt", "Muon Pt", 500, 0, 500);
   h_Muon_Pt->SetXTitle("Generated Muon pT [GeV]");
   h_Muon_Pt->Sumw2();
   //histograms.push_back(h_Muon_Pt);
   histograms_MC.push_back(h_Muon_Pt);
  
   //Pt of electrons 
   h_Electron_Pt = new TH1F("Electron_Pt", "Electron Pt", 500, 0, 500);
   h_Electron_Pt->SetXTitle("Generated Electron pT [GeV]");
   h_Electron_Pt->Sumw2();
   //histograms.push_back(h_Electron_Pt);
   histograms_MC.push_back(h_Electron_Pt);
  
   //Pt of taus 
   h_Tau_Pt = new TH1F("Tau_Pt", "Tau Pt", 500, 0, 500);
   h_Tau_Pt->SetXTitle("Generated Tau pT [GeV]");
   h_Tau_Pt->Sumw2();
   //histograms.push_back(h_Tau_Pt);
   histograms_MC.push_back(h_Tau_Pt);

   //Invariant mass (M) of leptons(l) and nuetrinos (n)=> (Mln) 
   h_Mln = new TH1F("Lepton_Neutrino_Inavriant Mass", "Lepton+Neutrino Inavriant Mass", 140, 10, 150);
   h_Mln->SetXTitle("Generated m_{ln} [GeV]");
   h_Mln->Sumw2();
   //histograms.push_back(h_Mln);
   histograms_MC.push_back(h_Mln);
   
   //Invariant mass (M) of quarks(q) and anti-quarks (qb)=> (Mqqb) 
   h_Mqqb = new TH1F("Quark_AntiQuark_Inavriant Mass", "Quark+AntiQuark Inavriant Mass", 140, 10, 150);
   h_Mqqb->SetXTitle("Generated m_{qqb} [GeV]");
   h_Mqqb->Sumw2();
   //histograms.push_back(h_Mqqb);
   histograms_MC.push_back(h_Mqqb);
   
   //Invariant mass (M) of hadronic top quark => (Mhadtop) 
   h_Mhadtop = new TH1F("Hadronic_Top_Inavriant Mass", "Hadronic Top Inavriant Mass", 30, 165, 180);
   h_Mhadtop->SetXTitle("Generated m_{hadtop} [GeV]");
   h_Mhadtop->Sumw2();
   //histograms.push_back(h_Mhadtop);
   histograms_MC.push_back(h_Mhadtop);
   
   //Transverse momentum (Pt) of hadronic top quark => (Pthadtop) 
   h_Pthadtop = new TH1F("Hadronic_Top_Transverse_Momentum", "Hadronic Top Transverse Momentum", 350, 0, 350);
   h_Pthadtop->SetXTitle("Generated Pt_{hadtop} [GeV]");
   h_Pthadtop->Sumw2();
   //histograms.push_back(h_Pthadtop);
   histograms_MC.push_back(h_Pthadtop);
   

   //Invariant mass (M) of leptonic top quark => (Mleptop) 
   h_Mleptop = new TH1F("Leptonic_Top_Inavriant Mass", "Leptonic Top Inavriant Mass", 30, 165, 180);
   h_Mleptop->SetXTitle("Generated m_{leptop} [GeV]");
   h_Mleptop->Sumw2();
   //histograms.push_back(h_Mleptop);
   histograms_MC.push_back(h_Mleptop);
   
   //Transverse momentum (Pt) of leptonic top quark => (Ptleptop) 
   h_Ptleptop = new TH1F("Leptonic_Top_Transverse_Momentum", "Leptonic Top Transverse Momentum", 350, 0, 350);
   h_Ptleptop->SetXTitle("Generated Pt_{leptop} [GeV]");
   h_Ptleptop->Sumw2();
   //histograms.push_back(h_Ptleptop);
   histograms_MC.push_back(h_Ptleptop);
   
//////////////////////////////
//   Reconstructed histograms 
//////////////////////////////
   //No. of muons
   h_NMuon_rec = new TH1F("Nmuon_rec", "Number of muon_rec", 10, 0, 10);
   h_NMuon_rec->SetXTitle("No. Rec Muons(BES)");
   h_NMuon_rec->Sumw2();
   histograms.push_back(h_NMuon_rec);
   //histograms_MC.push_back(h_NMuon_rec);

   //No. of iso-muons 
   h_NIsoMuon_rec = new TH1F("NMuon_rec", "Number of iso-muons_rec", 7, 0, 7);
   h_NIsoMuon_rec->SetXTitle("No. Rec Muons(Iso)(BES)");
   h_NIsoMuon_rec->Sumw2();
   histograms.push_back(h_NIsoMuon_rec);
   //histograms_MC.push_back(h_NIsoMuon_rec);

   //Invariant mass (M) of Di-muon (mumu) which are reconstructed (rec) => (Mmumu_rec)
   h_Mmumu_rec = new TH1F("Mmumu_rec", "Invariant di-muon mass_rec", 60, 60, 120);
   h_Mmumu_rec->SetXTitle("Rec M_{#mu#mu}(BES)");
   h_Mmumu_rec->Sumw2();
   histograms.push_back(h_Mmumu_rec);
   //histograms_MC.push_back(h_Mmumu_rec);
 
 
   //No. of jets
   h_NJet_rec = new TH1F("Njet_rec", "Number of jets_rec", 10, 0, 10);
   h_NJet_rec->SetXTitle("No. Rec Jets(BES)");
   h_NJet_rec->Sumw2();
   histograms.push_back(h_NJet_rec);
   //histograms_MC.push_back(h_NJet_rec);
 
   //No. of b-jets
   h_NbJet_rec = new TH1F("Nbjet_rec", "Number of bjets_rec", 10, 0, 10);
   h_NbJet_rec->SetXTitle("No. Rec bJets(BES)");
   h_NbJet_rec->Sumw2();
   histograms.push_back(h_NbJet_rec);
   //histograms_MC.push_back(h_NbJet_rec);

   //Missing Energy
   h_met_Pt_rec = new TH1F("met_Pt_rec", "met Pt", 30, 5, 305);
   h_met_Pt_rec->SetXTitle("Rec met pT [GeV](BES)");
   h_met_Pt_rec->Sumw2();
   histograms.push_back(h_met_Pt_rec);
   //histograms_MC.push_back(h_met_Pt_rec);
 
  
   //Transverse momentum(Pt) of muons
   h_Muon_Pt_rec = new TH1F("Muon_Pt_rec", "Muon Pt_rec", 30, 0, 300);
   h_Muon_Pt_rec->SetXTitle("Rec Muon pT [GeV](AES)");
   h_Muon_Pt->Sumw2();
   histograms.push_back(h_Muon_Pt_rec);
   //histograms_MC.push_back(h_Muon_Pt_rec);

  
  




}

Bool_t MyAnalysis::Process(Long64_t entry) {
   // The Process() function is called for each entry in the tree (or possibly
   // keyed object in the case of PROOF) to be processed. The entry argument
   // specifies which entry in the currently loaded tree is to be processed.
   // It can be passed to either MyAnalysis::GetEntry() or TBranch::GetEntry()
   // to read either all or the required parts of the data. When processing
   // keyed objects with PROOF, the object is already loaded and is available
   // via the fObject pointer.
   //
   // This function should contain the "body" of the analysis. It can contain
   // simple or elaborate selection criteria, run algorithms on the data
   // of the event and typically fill histograms.
   //
   // The processing can be stopped by calling Abort().
   //
   // Use fStatus to set the return value of TTree::Process().
   //
   // The return value is currently not used.
   
   ++TotalEvents;
   
   GetEntry(entry);
   
   //if (TotalEvents % 10000 == 0)
   //   cout << "Next event -----> " << TotalEvents << endl;
   BuildEvent();
   
   double MuonPtCut = 25.;
   double MuonRelIsoCut = 0.09;
   
   
   //*****************************************************************
   // Assignment 1 : Calc. of branching ratio
   //***************************************************************** 
     //Calc. of Br. of taus
     if(MCleptonPDGid == 15 || MCleptonPDGid == -15){
        ++N_Tau;
     }

     //Fiducial region 
     bool truthCuts{(MCleptonPDGid == 13 || MCleptonPDGid == -13) && (lepWl.Pt() > 25) && //'Exactly One Muon with min pT 25 GeV'
                    (hadB.Pt() > 30 && lepB.Pt() > 30)};                                  //'b-quarks have min pT 30 GeV'
         if(truthCuts) 
            ++N_GenFid; 
   //**********************************************************
   // Assignment 2 : Kinematic varaiables of "Generated" particles
   //**********************************************************  
     //pT of taus 
     if(MCleptonPDGid == 15 || MCleptonPDGid == -15){
        h_Tau_Pt->Fill(lepWl.Pt());
     }
   //**********************************************************
   // Assignment 3 : W boson mass
   //**********************************************************  

     h_Mqqb->Fill((hadWq + hadWqb).M()); 

   //**********************************************************
   // Assignment 4 : top-quark mass
   //**********************************************************  
     h_Pthadtop->Fill((hadWq + hadWqb + hadB).Pt());
     h_Mhadtop->Fill((hadWq + hadWqb + hadB).M()); 

////////////////////////////////////////////////
//     Filling Histograms and Event Selection
////////////////////////////////////////////////

//--------Looking at reconstructed variables to determine 'first' cuts--------
     // Reconstructed Nr. of Muons
     h_NMuon_rec->Fill(NMuon, EventWeight);
     // Reconstructed Nr. of ISOLATED Muons
     int N_IsoMuon = 0;
     MyMuon *muon1, *muon2;
     for (vector<MyMuon>::iterator jt = Muons.begin(); jt != Muons.end(); ++jt) {
//      if (jt->IsIsolated(MuonRelIsoCut)) {
        ++N_IsoMuon;
        if (N_IsoMuon == 1) muon1 = &(*jt);
        if (N_IsoMuon == 2) muon2 = &(*jt);
//      }
     }
     h_NIsoMuon_rec->Fill(N_IsoMuon, EventWeight);
     // Reconstructed Invariant Mass of two Muons
     if (N_IsoMuon > 1 && triggerIsoMu24) {
      if (muon1->Pt()>MuonPtCut) {
         h_Mmumu_rec->Fill((*muon1 + *muon2).M(), EventWeight);
      }
    }
     // Reconstructed Nr. of Jets
     h_NJet_rec->Fill(NJet, EventWeight);
     // Reconstructed Nr. of bjets
     int btagged = 0;
     int Nbtagged_rec = 0;
     for (vector<MyJet>::iterator jt = Jets.begin(); jt != Jets.end(); ++jt) {
        if((jt->GetBTagDiscriminator()) > 1.74)
           ++Nbtagged_rec;
     }
     h_NbJet_rec->Fill(Nbtagged_rec, EventWeight);
     h_met_Pt_rec->Fill((met.Pt()), EventWeight);

   //**********************************************************
   // Assignment 5: Cross section measurement of ttbar
   //**********************************************************  

   int TrueJetCounter = 0;
   int btaggedJetCounter= 0; 
   for (vector<MyJet>::iterator jt = Jets.begin(); jt != Jets.end(); ++jt) {
     if((jt->GetJetID()==1) && (jt->Pt() > 30 ))  //This is just for counting (NOT a cut!)
        ++TrueJetCounter;
     if((jt->GetBTagDiscriminator()) > 1.74)      //same here (NOT a cut!)
        ++btaggedJetCounter;
   }
   
   #if 0
   bool recoCuts{(NMuon == 1) && ((muon1->Pt())>MuonPtCut)  &&  //'Exactly One Muon with min pT 25 GeV'
                 (triggerIsoMu24)                           &&  //'Muon Trigger'             
                 (muon1->IsIsolated(MuonRelIsoCut))         &&  //'Muon Isolation of 0.09' 
                 (TrueJetCounter > 3)                       &&  //'At least 4 Good Jets'
                 (btaggedJetCounter > 1)                        //'At least 2 bjets'
        };
   #endif

   //START of applying cuts
//   if(NMuon == 1){                                      //'Exactly one Muon' cut
//      ++NMuon_cut;
//      if((muon1->Pt())>MuonPtCut){                    //'Exactly One Muon with min pT 25 GeV' cut
//         ++OneMuonPt_cut;
//         if(triggerIsoMu24){                         //'Muon Trigger' cut
//            ++trig_cut;
//            if(muon1->IsIsolated(MuonRelIsoCut)){   //'Muon Isolation of 0.09' cut
//               ++MuonIso_cut;
//               if( TrueJetCounter > 3){           //'At least 4 Good Jets' cut
//                  ++TrueJet_cut;
//                  if(btaggedJetCounter > 1){     //'At least 2 bjets' cut
                                                       //btagging is applied which gives a good probability
                                                       //of the jet to originate from a b-quark
//                     ++btag_cut;
                     FinalWeightedNEvent += EventWeight;
                     h_Muon_Pt_rec->Fill((muon1->Pt()), EventWeight);
//                  }
//               } 
//            }
//         }
//      }
//   }

     #if 0
                        if(recoCuts)
                            FinalWeightedNEvent += EventWeight;

                       if(truthCuts && recoCuts)
                            PassFiducialNSelection++;
     #endif
//-----------------------------------------
   //////////////////////////////

   return kTRUE;
}

void MyAnalysis::SlaveTerminate() {
   // The SlaveTerminate() function is called after all entries or objects
   // have been processed. When running with PROOF SlaveTerminate() is called
   // on each slave server.
     TFile *fout = new TFile( Form("output.root"), "recreate" );
     h_Muon_Pt_rec->Write();     
     fout->Close();
     //Printing on Terminal 
     cout<<"No. initial events: "<< TotalEvents <<endl;
     cout<<"No. of Generated Electrons: "<<N_Electron<<endl;
     cout<<"No. of Generated Muons: "<<N_Muon<<endl;
     cout<<"No. of Generated Muons in the fiducial region: "<<N_GenFid<<endl;
     cout<<"No. of Generated Taus: "<<N_Tau<<endl;
     cout<<"------------------------------------------ "<<endl;
     cout<<"--------------Event Selection------------- "<<endl;
     cout<<"No. of Reconstructed events initially': "<<TotalEvents<<endl;
     cout<<"No. of Reconstructed events after 'At least one Muon' cut: "<<NMuon_cut<<endl;
     cout<<"No. of Reconstructed events after 'One Muon with min pT 25 GeV' cut: "<<OneMuonPt_cut<<endl;
     cout<<"No. of Reconstructed events after 'Muon Trigger' cut: "<<trig_cut<<endl;
     cout<<"No. of Reconstructed events after 'Muon Isolation of 0.09' cut: "<<MuonIso_cut<<endl;
     cout<<"No. of Reconstructed events after 'AT least 4 Good Jets (true jets with min pT of 30 GeV)' cut: "<<TrueJet_cut<<endl;
     cout<<"No. of Reconstructed events after 'At least 2 bjets' cut: "<<btag_cut<<endl;
     cout<<"No. of FINAL Reconstructed events scaled to data (for data weight is 1): "<<FinalWeightedNEvent<<endl;
//     cout<<"No. of Events passing Fiducial and selection                           : "<<PassFiducialNSelection<<endl;
     cout<<"------------------------------------------ "<<endl;
     cout<<"------------------------------------------ "<<endl;

}

void MyAnalysis::Terminate() {
   // The Terminate() function is the last function to be called during
   // a query. It always runs on the client, it can be used to present
   // the results graphically or save the results to file.
   
}
