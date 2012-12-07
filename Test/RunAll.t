#!/usr/bin/perl

#use Test::HardwareLpar::TestHWLparReconQueue;

#Test::Common::StagingBasedTest->SKIP_CLASS(1);
use Test::PvuRecon::PvuModelTest;
use Test::PvuRecon::ReconInstalledSoftwareTest;
use Test::PvuRecon::ReconPvuInfoTest;
use Test::PvuRecon::PvuReconEngineTest;
use Test::Recon::InstalledSoftwareTest;

Test::Class->runtests;
