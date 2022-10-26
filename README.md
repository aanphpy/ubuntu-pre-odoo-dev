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
- XML by Red Hat

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
