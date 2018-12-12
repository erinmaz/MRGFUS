cd /Volumes/Pikelab/INCOMING/MRGFUS
for f in `ls -d 9*` `ls -d W*` `ls -d HIFU*` `ls -d hifu*`
do 
cd /Volumes/Pikelab/INCOMING/MRGFUS/${f}
for scan in `ls -d *SAG_FSPGR_BRAVO*` `ls -d *Sag_CUBE_T2*` `ls -d *Ax_FLAIR*` `ls -d *QSM*` `ls -d *rsBOLD*` `ls -d *DWI*`
do
cd /Volumes/Pikelab/INCOMING/MRGFUS/${f}/${scan}
firstfile=`ls | head -1` 
TR=`dicom_hinfo -tag 0018,0080 -no_name $firstfile`
TE=`dicom_hinfo -tag 0018,0081 -no_name $firstfile`
echo $f $scan $TR $TE
done
done