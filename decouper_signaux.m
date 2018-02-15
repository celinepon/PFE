function decouper_signaux(signal,freq)

filename_C= 'R:\vsld\2018-pfe-polytech-TIS5\data\2016-HOOMIJ\VISURESP\C1_17_05_2016.rcg';
delimiterIn_C = '\t';
headerlinesIn_C = 38;
fichierComplet=importdata(filename_C,delimiterIn_C,headerlinesIn_C);
thorax_C=fichierComplet.data(1:end,1);
abdomen_C=fichierComplet.data(1:end,2);
volume_C=fichierComplet.data(1:end,11);
debit_C=fichierComplet.data(1:end,12);

couper(1)=63080;
couper(2)=68000;



fichier1(:,1)=vertcat(thorax_C(1:couper(1)),thorax_C(couper(2):end));
fichier1(:,2)=vertcat(abdomen_C(1:couper(1)),abdomen_C(couper(2):end));
fichier1(:,3)=vertcat(volume_C(1:couper(1)),volume_C(couper(2):end));
fichier1(:,4)=vertcat(debit_C(1:couper(1)),debit_C(couper(2):end));

fichierFinal.textdata=fichierComplet.textdata;
fichierFinal.colheaders={'THO','ABD','VolRec','DebRec'};
fichierFinal.data(:,1)=fichier1(:,1);
fichierFinal.data(:,2)=fichier1(:,2);
fichierFinal.data(:,3)=fichier1(:,3);
fichierFinal.data(:,4)=fichier1(:,4);

 struct_tmp = fichierFinal;
    name_mat = ['R:\vsld\2018-pfe-polytech-TIS5\data\2016-HOOMIJ\VISURESP\C1_17_05_2016_sans_artefact.rcg'];
    save(name_mat, 'struct_tmp');
    
    