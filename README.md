# Ubuntu 22.04 Pre Odoo Dev

Anda bisa mendownload `init_install.sh` jika diasumsikan belum menginstall `git`

```sh
chmod u+x init_install.sh
./init_install.sh
```

Prosedur dibawah ini dijalankan setelah menjalankan script `init_install.sh`:

# Install Docker Desktop

Jalankan:

```sk
kvm-ok
```
Contoh output:

```
INFO: /dev/kvm exists
KVM acceleration can be used
```

Jika output yang muncul seperti diatas, silahkan lanjutkan ke langkah 
berikutnya.


# VS Code Additional Config

Plugins:
- Python by Microsoft
- Pylance by Microsoft
- Docker by Microsoft
- IntelliCode by Microsoft

Themes:
- VSC Military Style

# PostgreSQL Additional Config

Create admin user

```sh
sudo su
nano /etc/postgresql/14/main/pg_hba.conf
```
 
Cari: `local   all             all                                peer`
ubah ke:  `local   all             all                                md5`

Untuk configurasi dibawah ini, password `admin` sesuaikan 
dengan konfigurasi `db_password` yang ada di file 
`$HOME/Projects/odoo/odoo14/odoo.conf`

```sh
sudo su
service postgresql restart
service postgresql@14-main retstart
su - postgres
createuser -P -s -e admin
```

# ODOO 14

```sh
cd $HOME/Projects/odoo/odoo14
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
python odoo-bin -c odoo.conf -d odoo14test -i base
```

# ODOO 12

Konfigurasi dan instalasi library pendukung odoo12

```sh
cd $HOME/Projects/odoo/odoo12
source venv/bin/activate
pip install --upgrade pip
pip install "setuptools<58.0.2"
pip install -r requirements.txt
pip install "Werkzeug<1"
pip install "libsass<1"
```

PostgresSQL Untuk Odoo 12 versi maksimumnya adalah PostgreSQL versi 12. File `init_install.sh` sudah menyiapkan docker container dengan nama `postgres10`:

```sh
docker stop postgres10
docker start postgres10
docker exec -it postgres10 bash
```

Setelah masuk di dalam CLI docker container `postgres10`:

```sh
apt update
apt install nano
nano /var/lib/postgresql/data/pgdata/pg_hba.conf
```

Di `nano` cari line:
```sh
local       all     all     trust
```
Replace dengan:
```sh
local       all     all     md5
```
Keluar dari docker container `postgres10`:
```
exit
```
Restart docker container `postgres10` dan buat user `admin` dengan password disesuaikan dengan configurasi `db_password` di `$HOME/Projects/odoo/odoo12/odoo.conf`:
```sh
docker stop postgres10
docker start postgres10
docker exec -it postgres10 bash
su - postgres
createuser -P -s -e admin
```
