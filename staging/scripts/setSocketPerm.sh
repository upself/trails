:
# quick script to set the perms bank for the socket files and move from secondary folder
mv -f /var/ftp/staging/secondary/*socket.tsv.gz /var/ftp/staging/secondary/socket_files
chmod 0664 /var/ftp/staging/secondary/socket_files/*socket*

mv -f /var/ftp/staging/secondary/*Version* /var/ftp/staging/secondary/tad4d_version
chmod 0664 /var/ftp/staging/secondary/tad4d_version/*

mv -f /var/ftp/staging/secondary/*endpoint.tsv* /var/ftp/staging/secondary/tmp_old_data
mv -f /var/ftp/staging/secondary/*_computer_memory.tsv* /var/ftp/staging/secondary/tmp_old_data 
