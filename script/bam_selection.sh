#! /bin/sh
#$ -S /bin/sh
#$ -cwd

export PYTHONPATH=$PYTHONPATH:#Input your PYTHONPATH

#Reference
Reference_fasta=xxx/xxx/xxx
#Text file with the path of the bam file
bam_file=/lustre7/home/s-saiga/average_depth_analysis/multi_align_Yotsuboshi_Houkou/Yotsuboshi_bam_bai/bam.txt
#used x\cpu
used_cpu=8
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#染色体の長さを取得
cd ../
echo 'Get the name of the chromosome...'
ln -s ${Reference_fasta}
Reference_fasta_fai=`echo ${Reference_fasta}|sed -e "s/.*\\///"`
if [ -e ${Reference_fasta_fai}.fai ]; then
  echo "Reference fai File exists."
else
  samtools faidx ${Reference_fasta_fai}
fi
echo 'finish'

mkdir bam_selection_result
cd bam_selection_result

echo 'bam selection...'
python ../script/bam_selection.py ../${Reference_fasta_fai}.fai ${bam_file}

#並行処理
cat bam_selection.txt|xargs -P${used_cpu} -I % sh -c %
echo 'finish'

echo "make bai"
cat bam_to_bai.txt|xargs -P${used_cpu} -I % sh -c %
echo 'finish'

mkdir bam_bai_pass
mv *.bam bam_bai_pass
mv *.bai bam_bai_pass
cd ..
