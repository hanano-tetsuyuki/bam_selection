#!/usr/bin/env python
# coding: UTF-8
#hello

import sys
import re
import pandas as pd
args = sys.argv
fasta_fai = args[1]
bam_file = args[2]
#----------------------------------------------------------------------------------------------------------------------------------------
z = open('bam_selection.txt',mode='w')
y = open('bam_to_bai.txt',mode='w')
a = open(bam_file,'r')
while True:
    line_1 = a.readline()
    if line_1:
        neo_line_1 = line_1.replace('\n','')
        bam_pass = re.sub('\S+/','',neo_line_1)
    else:
        break
df = pd.read_table(fasta_fai,sep='\t',header=None,names=['name','length','total_lendth','A','B'])
fai_length = len(df)
for item in range(fai_length):
    tig_name = df.at[item,'name']
    z.write('samtools view -@ 10 -b '+neo_line_1+' '+tig_name+'> '+tig_name+'_'+bam_pass+'\n')
    y.write('samtools index '+tig_name+'_'+bam_pass+'\n')
