function decouper_signaux(signal,freq)

filename_C= 'R:\vsld\2018-pfe-polytech-TIS5\data\2016_0426_HugoBOXX\VISURESP\Beatbox.rcg';
delimiterIn_C = '\t';
headerlinesIn_C = 38;
fichierComplet=importdata(filename_C,delimiterIn_C,headerlinesIn_C);
fichierFinal='';
fichierFinal.colheaders=fichierComplet.colheaders;
variable=fichierComplet.colheaders;
couper(1)=74490;
couper(2)=77830;

for i=1:length(fichierComplet.colheaders)
variable{i}=fichierComplet.data(1:end,i);
donnees=variable{i};
fichierFinal.data(:,i)=vertcat(donnees(1:couper(1)),donnees(couper(2):217400));
end

fichierFinal.textdata=fichierComplet.textdata;

 struct_tmp = fichierFinal;
    name_mat = ['R:\vsld\2018-pfe-polytech-TIS5\data\2016_0426_HugoBOXX\VISURESP\Beatbox_sans_artefact.rcg'];

    save(name_mat, 'struct_tmp');
end