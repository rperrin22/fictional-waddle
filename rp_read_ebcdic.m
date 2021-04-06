function rp_read_ebcdic(filename)


[~,~,SegyHeader]=ReadSegy(filename);

bob=char(ebcdic2ascii(SegyHeader.TextualFileHeader));

bob = reshape(bob,80,40)';

disp(bob);