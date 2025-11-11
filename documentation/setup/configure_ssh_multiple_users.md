
#  configure ssh multiple users git - [reference commit](https://github.com/DeykyPinheiro/nsub/commit/ca3c9310d3bc086081446712e70f9c36053b4fb8)


fist, create diferent keys, work and personal

need configure a file, named config in ~/.ssh/
```
# === perssonal account (GitHub) ===
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_github_pessoal
    IdentitiesOnly yes

# === work account (Bitbucket) ===
Host bitbucket.org
    HostName bitbucket.org
    User git
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
```

looks like this:
```
 ~/.ssh $ ls -l total 29 
    -rw-r--r-- 1 Dell 197121 318 Nov 5 21:13 config 
    -rw-r--r-- 1 Dell 197121 399 Nov 3 20:58 id_github_pessoal #  personal key
    -rw-r--r-- 1 Dell 197121 96 Nov 3 20:58 id_github_pessoal.pub 
    -rw-r--r-- 1 Dell 197121 2602 May 3 2024 id_rsa  # work key
    -rw-r--r-- 1 Dell 197121 566 May 3 2024 id_rsa.pub
    -rw-r--r-- 1 Dell 197121 1611 Jul 8 2024 id_rsa_putty.ppk 
    -rw-r--r-- 1 Dell 197121 477 Jul 8 2024 id_rsa_putty.pub 
    -rw-r--r-- 1 Dell 197121 5244 Oct 23 11:25 known_hosts 
    -rw-r--r-- 1 Dell 197121 4500 Oct 23 11:25 known_hosts.old
```


configure creditiails global:
```
git config --global user.name Deyky Pinheiro
git config --global user.email deyky.pinheiro@work.com.br
```

personal credentials:
```
cd path/of/repository-personal
git config user.name "Deyky Pinheiro"
git config user.email "seu_email_pessoal@exemplo.com"
```

## diferent account in one serve git, exemple with github
file config
```
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_github_pessoal
    IdentitiesOnly yes

Host github-trabalho
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
```

when clone with personal credentials
```
git clone git@github-personal:usuario/repositorio.git
```

or work credentials
```
git clone git@github-work:empresa/repositorio.git
```

