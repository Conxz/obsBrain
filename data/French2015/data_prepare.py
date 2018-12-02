# code for updating gene expression from French2015
import pandas as pd
import os

#raw_dir = './RAW'
raw_dir = '../../../obsbrain_RAW/French2015/RAW/'
new_dir = './obs.DAT'
if not os.path.exists(new_dir):
    os.mkdir(new_dir)
cols_update_file = 'obs.colsUpdate.csv' # prepared based on data format
raw_file = os.path.join(raw_dir, 'AllenHBA_DK_ExpressionMatrix.tsv')

cols_update_dat = pd.read_csv(cols_update_file)
raw_dat = pd.read_csv(raw_file, sep='\t')

cols_update_dat = pd.read_csv(cols_update_file)
update_col_dict = dict(zip(cols_update_dat['RawCols'], cols_update_dat['NewCols']))
raw_dat.rename(columns={u'Unnamed: 0':'X'}, inplace=True) #fixed column name missing in raw data

raw_dat.rename(columns=update_col_dict, inplace=True)

# save gene list in the database
gene_list = raw_dat['X']
gene_list.to_csv('obs.gene_list.csv', index=False, header=False)

# save area list
cols_list = raw_dat.columns[2:]
area_list = [col.split('-')[2] for col in cols_list]
area_list_pd = pd.DataFrame()
area_list_pd['Area'] = area_list
area_list_pd.to_csv('obs.area_list.csv', index=False, header=False)

# save hemi list
hemi_list = [col.split('-')[1] for col in cols_list]
hemi_list_pd = pd.DataFrame()
hemi_list_pd['Hemi'] = hemi_list
hemi_list_pd.to_csv('obs.hemi_list.csv', index=False, header=False)

# save gene expression for each gene
#for gene in gene_list:
#    gene_dat = raw_dat[raw_dat['X']==gene][cols_list]
#    out_file = os.path.join(new_dir, gene+'.obs')
#    gene_dat.to_csv(out_file, index=False, header=False)

gene_dat = raw_dat[cols_list]
gene_dat = gene_dat.T
gene_dat.columns=gene_list
#print gene_dat.head()
out_file = os.path.join(new_dir, 'obsDat.csv')
gene_dat.to_csv(out_file, index=False)

#print gene_dat.head()
out_file = os.path.join(new_dir, 'obsDat.feather')
gene_dat.reset_index(inplace=True)
#print gene_dat.head()
gene_dat.to_feather(out_file)


