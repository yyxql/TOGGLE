package tophat;

###################################################################################################################################
#
# Copyright 2014 IRD-CIRAD
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/> or
# write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# You should have received a copy of the CeCILL-C license with this program.
#If not see <http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.txt>
#
# Intellectual property belongs to IRD, CIRAD and South Green developpement plateform
# Written by Cecile Monat, Christine Tranchant, Ayite Kougbeadjo, Cedric Farcy, Mawusse Agbessi, Marilyne Summo, and Francois Sabot
#
###################################################################################################################################

use strict;
use warnings;

use lib qw(.);
use localConfig;
use toolbox;
use Data::Dumper;

#tophat2 INDEX-BOWTIE-BUILD
sub bowtieBuild
{
    my($refFastaFileIn,$optionsHachees)=@_;
    $refFastaFileIn =~ /^([^\.]+)\./;   # catch o,ly the file name without the file extension and store it into $prefixRef variable
    my $prefixRef = $1;
    ##DEBUG
    toolbox::exportLog("INFOS: tophat::bowtieBuild : $prefixRef\n",1);
    
    if (toolbox::sizeFile($refFastaFileIn)==1)		##Check if the reference file exist and is not empty
    {
        my $options=toolbox::extractOptions($optionsHachees, " ");		##Get given options
        my $command=$bowtieBuild.$options." ".$refFastaFileIn." ".$prefixRef;		##command
        ##DEBUG
        toolbox::exportLog("INFOS: tophat::bowtieBuild : $command\n",1);
        #Execute command
        if(toolbox::run($command)==1)		##The command should be executed correctly (ie return) before exporting the log
	{
            toolbox::exportLog("INFOS: tophat::bowtieBuild : correctly done\n",1);		# bowtiebuild have been correctly done
        }
        else
        {
            toolbox::exportLog("ERROR: tophat::bowtieBuild : ABORTED\n",0);		# bowtiebuild have not been correctly done
            return 0;
        }
    }
    else
    {
        toolbox::exportLog("ERROR: tophat::bowtiebBuild : Problem with the file $refFastaFileIn\n",0);		# bowtiebuild can not function because of wrong/missing reference file
        return 0;
    }
    return $prefixRef;
}

##tophat2 INDEX-BOWTIE2-BUILD
sub bowtie2Build
{
    my($refFastaFileIn,$optionsHachees)=@_;
    $refFastaFileIn =~ /^([^\.]+)\./;  # catch o,ly the file name without the file extension and store it into $prefixRef variable
    my $prefixRef = $1;
    ##DEBUG
    toolbox::exportLog("INFOS: tophat::bowtie2Build : $prefixRef\n",1);
    
    if (toolbox::sizeFile($refFastaFileIn)==1)		##Check if the reference file exist and is not empty
    {
        my $options=toolbox::extractOptions($optionsHachees, " ");		##Get given options
        my $command=$bowtie2Build.$options." ".$refFastaFileIn." ".$prefixRef;		##command
        ##DEBUG
        toolbox::exportLog("INFOS: tophat::bowtieBuild : $command\n",1);
        #Execute command
        if(toolbox::run($command)==1)		##The command should be executed correctly (ie return) before exporting the log
	{
            toolbox::exportLog("INFOS: tophat::bowtie2Build : correctly done\n",1);		# bowtie2build have been correctly done
        }
        else
        {
            toolbox::exportLog("ERROR: tophat::bowtie2Build : ABORTED\n",0);		# bowtie2build have not been correctly done
            return 0;
        }
    }
    else
    {
        toolbox::exportLog("ERROR: tophat::bowtie2bBuild : Problem with the file $refFastaFileIn\n",0);		# bowtie2build can not function because of wrong/missing reference file
        return 0;
    }
    return $prefixRef;
}

sub tophat2
{
    my ($tophatDirOut, $prefixRef, $forwardFastqFileIn,$reverseFastqFileIn,$gffFile,$optionsHachees)=@_;
    my $options="";
    if ($optionsHachees)
    {
        $options=toolbox::extractOptions($optionsHachees);		##Get given options
    }
    
    if ((toolbox::sizeFile($forwardFastqFileIn)==1) and (toolbox::sizeFile($reverseFastqFileIn,0)==1) and (toolbox::sizeFile($gffFile)==1))		##Check if entry files exist and are not empty
    {
        my $command=$tophat2.$options." -G ".$gffFile." -o ".$tophatDirOut." ".$prefixRef." ".$forwardFastqFileIn." ".$reverseFastqFileIn;		# command line
     	#my $command2="$tophat2 $options -G $gffFile -o $tophatDirOut $refFastaFileIn $forwardFastqFileIn $reverseFastqFileIn";		# command line
 
        ##DEBUG
        toolbox::exportLog("INFOS: tophat::topHat2 : $command\n",1);

        # Command is executed with the run function (package toolbox)
        if (toolbox::run($command)==1)
        {
            toolbox::exportLog("INFOS: tophat : correctly done\n",1);
            return 1;
        }
        else
        {
            toolbox::exportLog("ERROR: tophat : ABBORTED\n",0);
            return 0;
        }
        
    }
    elsif ((toolbox::sizeFile($forwardFastqFileIn)==1) and (toolbox::sizeFile($reverseFastqFileIn,0)==0) and (toolbox::sizeFile($gffFile)==1))		##Check if entry files exist and are not empty
    {
        my $command=$tophat2.$options." -G ".$gffFile." -o ".$tophatDirOut." ".$prefixRef." ".$forwardFastqFileIn;		# command line
 
        ##DEBUG
        toolbox::exportLog("INFOS: tophat::topHat2 : $command\n",1);

        # Command is executed with the run function (package toolbox)
        if (toolbox::run($command)==1)
        {
            toolbox::exportLog("INFOS: tophat : correctly done\n",1);
            return 1;
        }
        else
        {
            toolbox::exportLog("ERROR: tophat : ABBORTED\n",0);
            return 0;
        }
        
    }
    else
    {
        toolbox::exportLog("ERROR: tophat::tophat2 : Problem with the files\n",0);
        return 0;
    }
    
    
}


1;

