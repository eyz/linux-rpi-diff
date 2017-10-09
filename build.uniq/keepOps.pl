#!/usr/bin/perl

open(KERNELFILES, "find linux -type f |");
while($kernelFileRaw = <KERNELFILES>) {
  chop($kernelFileRaw);
  ($kernelFile) = $kernelFileRaw =~ /^linux\/(.+)$/;
  $kernelFiles{$kernelFile} = 1;
}

open(BUILDUNIQOUT, "cat build.*.uniq.sorted.log |");
while($buildFileRaw=<BUILDUNIQOUT>) {
  chop($buildFileRaw);
  ($op, $buildFile) = $buildFileRaw =~ /^\s*\d+\s+(\w+)\(\d+<\/home\/build\/linux\/(.+?)>/;
  $buildFiles{$buildFile} = 1;
}

chdir "linux";
foreach $kernelFile (keys(%kernelFiles)) {
  if (!exists($buildFiles{$kernelFile})) {
    if (-e "$kernelFile" && (! -d "$kernelFile") && $kernelFile !~ /\.git/) {
      print "git rm $kernelFile\n";
      system("git rm $kernelFile");
    }
  }
}
