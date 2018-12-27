# obsBrain
Observatory of Brain

- With this application, researchers could easily search and visualise regional effects in the human brain. 
- Data display is based on the Desikan–Killiany atlas (with 34 parcels in each hemisphere) from [FreeSurfer](https://surfer.nmr.mgh.harvard.edu/), which has been widely used in multi-site collaborative project, e.g., ENIGMA. 
- Links: Scripts on Github [obsBrain](https://github.com/Conxz/obsBrain) and application online [obsBrain](https://conxz.shinyapps.io/obsbrain/). 
- We would like to acknowledge to [shiny](https://shiny.rstudio.com/), [ggseg](https://github.com/LCBC-UiO/ggseg), and [feather](https://cran.r-project.org/web/packages/feather/index.html) R packages.


**Gene in Brain**
- With this application, researchers could easily research and explore regional gene expression in the human brain. 
- In the current version, two data sources of gene expression are included ([French et al., 2015](https://dx.doi.org/10.3389%2Ffnins.2015.00323); [Arnatkeviciute et al., 2018](https://doi.org/10.1101/380089)), both of which are derived from the [Allen Human Brain Atlas](http://human.brain-map.org/). 

**ENIGMA in Brain**
- With this tab, researchers could easily check published ENIGMA results which are based on the Desikan–Killiany atlas. 
- Note that for several studies, such as brain asymmetry studies and studies using averaged measures of two hemispheres, the results are only display in one hemispheres. 
- Color bar limits of effect sizes (Conhen's *d*) can be adjust via 'Color bar limits' for a better display. 
- For more details, please refer to the corresponding papers: Lateralization ([Kong et al., 2018, PNAS](https://www.ncbi.nlm.nih.gov/pubmed/29764998)), MDD ([Schmaal et al., 2017, Molecular Psychiatry](https://www.ncbi.nlm.nih.gov/pubmed/27137745)), OCD ([Boedhoe et al., 2018, AJP](https://www.ncbi.nlm.nih.gov/pubmed/29377733)), ASD ([van Rooij et al., 2018, AJP](https://www.ncbi.nlm.nih.gov/pubmed/29145754)), SCZ ([van Erp et al., 2018, Biological Psychiatry](https://www.ncbi.nlm.nih.gov/pubmed/29960671)), BD ([Hibar et al., 2018, Molecular Psychiatry](https://www.ncbi.nlm.nih.gov/pubmed/28461699))
- Gene Table shows gene association analysis results for corresponsing effects. The association analyses were based on Spearman correltion across brain areas between regional effects and the gene expression. Here are several relevant papers: [Kong et al., 2017](https://www.ncbi.nlm.nih.gov/pubmed/26733530); [Romero-Garcia et al., 2018](https://www.ncbi.nlm.nih.gov/pubmed/29483624); [Romme et al., 2017](https://www.ncbi.nlm.nih.gov/pubmed/27720199). 
- You can access ENIGMA publication via this [webpage](http://enigma.ini.usc.edu/publications/).

**obsBrain Viewer**
- With this tab, researchers could easily visualise regional effects based on the Desikan–Killiany atlas. 
- Prepare file based on this [input file template](https://github.com/Conxz/obsBrain/blob/master/info/obsDat.csv). Note that do NOT change the first two columns (i.e., 'area' and 'hemi'). Other useful files are provided [Here](https://github.com/Conxz/obsBrain/tree/master/info/). 

**Contact**
- If you have any questions about this application, please feel free to contact me (Xiangzhen Kong, MPI, Nijmegen) via Email *xiangzhen.kong AT outlok.com* or Twitter [@xiangzhenkong](https://twitter.com/xiangzhenkong) or Github [obsBrain](https://github.com/Conxz/obsBrain).
- Updated on Dec. 27, 2018.


