# code for updating gene expression from ..2018

from scipy.io import loadmat
import pandas as pd
import os

#raw_dir = './RAW'
raw_dir = '../../../obsbrain_RAW/Arnatkeviciute2018/RAW/'
mat = loadmat(os.path.join(raw_dir, 'ROIxGene_aparcaseg.mat'))
mat.keys()

new_dir = './obs.DAT'
if not os.path.exists(new_dir):
    os.mkdir(new_dir)

gene_list = [gene[0][0] for gene in mat['probeInformation'][0][0][1]]
"""
for i, gene in enumerate(gene_list):
    col_idx = i+1
    gene_dat = mat['parcelExpression'][:,col_idx]
    out_file = os.path.join(new_dir, gene+'.obs')
    gene_dat_df = pd.DataFrame()
    gene_dat_df['X'] = gene_dat
    gene_dat_df.to_csv(out_file, index=False, header=False)
"""
# save gene list in the database
gene_list_pf = pd.DataFrame()
gene_list_pf['X'] = gene_list
gene_list_pf.to_csv('obs.gene_list.csv', index=False, header=False)

# save hemi list
hemi_list = ['lh']*34
hemi_list_pd = pd.DataFrame()
hemi_list_pd['Hemi'] = hemi_list
hemi_list_pd.to_csv('obs.hemi_list.csv', index=False, header=False)

gene_dat = mat['parcelExpression'][:,1:]
out_file = os.path.join(new_dir, 'obsDat.csv')
gene_dat_df = pd.DataFrame(data=gene_dat, columns=gene_list)
gene_dat_df.to_csv(out_file, index=False)

out_file = os.path.join(new_dir, 'obsDat.feather')
gene_dat_df.reset_index(inplace=True)
gene_dat_df['index']=u'r' + gene_dat_df['index'].astype(str)
gene_dat_df.columns = gene_dat_df.columns.map(str)
gene_dat_df.to_feather(out_file)
