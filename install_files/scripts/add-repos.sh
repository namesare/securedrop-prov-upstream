#!/bin/bash
# Usage: source ./add-repos.sh
# Description: Downloads the tor signing key
# and adds the tor repo, and updates apt sources

set -e
set -x
add_signing_key() {
    signing_key="$1"
    cat ./"$signing_key" | apt-key add -
}


add_repo() {
    repo_name="$1"
    repo_url="$2"
    if [ ! -f /etc/apt/sources.list.d/$repo_name.list ]; then
        echo "deb $repo_url precise main" > /etc/apt/sources.list.d/$repo_name.list
    fi
}

tor_url="http://deb.torproject.org/torproject.org"
cat > tor_signing_key << EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

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
i9qvtbHz7Sa2iTQ3TFOQm6c3yuTG9VS6HfbMmUWW9lfi7rVljjAjeE/PTvYAUF2q
/4HrjkeuTTgdu73eJnlmBwgI1mmnJ3rFl4G+poRldL5m/3YcJvEgFL0/vMHexeZB
PnuO6xVJR1C18nCJAhwEEAECAAYFAlB7MXIACgkQU5xDa4LkC/fbpRAAsHOvH3Xi
6z+VP6ESd/PlpEMTtPA6Gu3bKY9XMu+t5Fxpc6du8b15XPcVjBJC2XhRums/rCN2
L1ui6tT2WM0ES7I4DCgzQzAzAecUd4OuZUVuCindKQrOfwkcbNoQz5OrpYodhNdj
f8qsIF07LWxA815mgXv+urhnbQJytBop13RPucATLtMtAhcScoJApraP4TnmLnzh
0iyHFVa827Cx95nrj1/YVMYzeESDnbsFnh4tCFlAseSMhj7TDQQH1/gCFWJl+61q
RB/m6pX2hGWCYeZCw3m8wqvILUbXkc70c9Iwl/2a+0mbtT7JI0TfnjC3ZDYLBfU1
0MtrxRTOWkaBHpx3g+YDJWvKQRZ22T/gAOJz627ilMlXH3ayyCIEBCiL8YynrUo9
zFdT07h+WDQcNiN6sa4Jq7/mJQpZosv1UF7d////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
//////////////////////////////////+JAhwEEAECAAYFAlFwaUEACgkQuW8j
AK0Ry+6hbA/9F4vOEUpaVz8Xfky83I7W6zP6q+z5KuUC3Bo1y/cN32KHSbD5sf5T
49VWBeWTWDQ1j2E01EvG3aZRz6aD22036FrRGSpRixiODVaP1sO5HRr7cOG25L2G
ESNasEFPdRtNxZPmXEqRSDLhKP4OHQ3vyykejaitQ3epHDdWQdjiFZzEC+Vet64S
/onsiTi5n7wwyAkWV3ihWEyadY6szC3XQPnxRG9mwbKkj50rSnYlK57nJ8FaRIyk
WwnzPZwI4EwA9Cr1LreaFdmI5GvElLinMnzvBxgb8fdHWmoXoj/j21YGXJnCLA5i
zR8UQlz2J0X+FLN6f+oMNCm/LiA0XjyJ/tIYS04G7W8QapYq82xq1o1yNiCPgFmE
OUweADFafQbtU1FWzHUPqfM7MQCUVr89CBB8JdJwldFXva4qgyTa646TzJvb62g5
bkuhL/RRuydSLvtW+Selk9tA9Dmy+wYEJTUFCkN4WxCTggxbkWW/VVVIS3Gd8uLz
0Cfgc8w33b6o1QNEzcT94uQWes92IHfIySMCANtqjkaH4JOzNDXXzGSGZEL6k0Ij
vkBL9fhXVatwAlSeJNsWAFFmvi3a1Z8syDHjhcy1WsqtpE6PtAfisQ4NIicEERZP
aGIl5abhBLWDlF+jKbi6vTbHGqHBcCwJcUYUpmKtcOhMwcN2zp0jRBeJAhwEEAEC
AAYFAlH4PMEACgkQIizoxDZEAoiNThAAiLbgqUUfWEvR3jkaxCzAUndiKiQXraOl
dFTbHv/4P5wlSoDiiaNoaRKfQaj4nYwbz9tBJP8SKh6/z8+0ek9VFbI6rUAJS54M
Wm/NcCbEQEDbk6R0NFaLLbLYJRLC7af84kGDr4LdMhHKirOzZiJcgOv1MOLs1xdQ
/YZ37ENbISHnN3fGKUBmX9I2RbveB6fYacbRZEyPO8n1JKphUUbDYvShpLJf4cje
6UDJta5hoe3BERyBwomlErtUx4gIRFHOYZDFpTNsG2xZ/WWFVRoKMg1soQ45+6oS
pxEaxeXcAnD+phRqPcITuFOJSlDSRwPDsbQ2+5g4WoGNMBlU6mvjm9s6oKoqni6k
2HYouwZwarMHL5G5uwSxs6Yi4MibKMUukYc5m/niYk0tD5INtstyP3oQ9nn6CDuK
nv57qAaoaEkQ5AtZ5d6NOTasBfnOCQe62aOpjupkh7reJeeWrzwHrq1ly3Z1jC/c
z23ZfYyTHdRHVTFBnzAmOZJhJLj0cN8hmHk0jPnxAfwB4+W0GTfbIzFIWrSWd0Yo
TKETaiYzI1jNK3QRxdyxpqKqumFD2I8nx8Jjb0w6QpFDP1Lc/805kVCuovfNq98l
fb6enHS6Y/3vE8ijAw+fRBkRaRN/au9wbezyzmN9Q06yL5lw9rOGPCpXq1fY69t8
rj0Ibe9N1wCJAhwEEAECAAYFAlMKFV0ACgkQDtqpReik/5eefxAAhNSjgqRqmhyD
XC6uCliN60bLP2kjo/C1XbtD3FZaMtZGdmGWweFKjUmG81j1AEgpvZBBT5YagFG1
Y8jGbQC1uGYYGUqxxFExh8oHRTakUTocYOHu1Y/NLM9YcpveihvIHZuaC0E2xYYH
GByhARILXy5mdgnZ9+To3kGFTsmc3k8PpN4oWiR6eCv4FWTHAHSxU/llqFzuVc2e
PuYNN62GzRnLENPOiD0CciYqUlHtC7+6GGHPaZiehtL22DO/KpG2JubF3tEvCUY7
B/r+NQDfCZiC83UHXut4HUbDKUr15Eh6bU48bS3ZRX+LqKT0EUyvCu6h5MN3U86c
Dv5IMtcLa1RsbAErg8QpsP8gx7jd0pDKloBhdCBarCXct/e314IB9bRf89FR1xLE
DxZaljqkWpPoSDUaJxKfBquG9JZyz0jcU2jt+gFy7dLr7A7qMrr+LM47KbOe7Mam
61CdUJm5UgvcUX5AL3mmilNSOdMFEXo7Wnajk58Q4AnZ/vpzdr+1m48HlnRZ+K+5
BfMMOwQLs7tJGRgy8IjxWz8fp+KOw6cpi1K8dFubnZHTMVYc8UIrfr+0VqhRWtw8
1sbIVhPaSUvXvsb57qYm5vPyfM8wuVbM/m61RhjyAzhQhoav+Y+50qZPaMWn/bmg
UqnFqIGtE6xdW/341DTVBi3FPkG57KiJAhwEEAECAAYFAlOASmoACgkQ8S2YV0Pu
JiCn8A/+MxtOvhvpWrKttqr9IEB83ZKlyao5aZCfm2IFG8b8WBXry/nl26AoyJoH
U6nDfMaAXeXzHN2MV24wUfWJkGC/uRqiiC5nu21XziDrEZUT/1eM66CFfgpyEhGu
lLxCptrtKvjq9is2YaE/pgyH0KY4bnJ2DQfozBeaIL2iwpj8bvU7I/z8rTvOIT6I
iZL6g6wKuefCTEEQMuTCjd6eBskygI0sr6qlK5q3DJ20jobLstpk4gGMS5/wjeYP
jCQpTVITp/rDzekQzMOrrELZjqEsLPWSihqYkDTxYnTW7WekiuN7zvfJjpDDRZ8T
kmynRZHiB2FtJwvhLibZD1ktb/aNYVvDPq00cB+jf/+dZmfYgjoYMl+B9ft1T1bq
mJ36nnZsAC6CGHqEONsf95UX0FpaiaYhW2OMcCSkdYnxXq84qmiMb6XKuvOLdh5P
DjizXgGx/FHH/xNxIrMz7WNc2l5PbukgeiGO+VFV0m2vDkxhQ6pMalW0foaGglKb
rawzX3oJsHtGSkQfROiM56fNCGxX575bgVWtvZARBCpYHdOSYYumJG33wU+W1k7t
8cmYxJqp75Y7FPGtyI/QWjJknFhAz426NBROUzGYB1LDkAcDCFUgea2t5MRkoemX
H3ziFJmKIrN2xNSvv8Byd0Nx1j0o3b+ndl/XXLqc+Viy/hOgNdOJAhwEEAEKAAYF
AlOAt7QACgkQt2GIO0QovcAROg//eRXbh0nJgJyrNaDY1YsdQAKR5cIY4uYpKhVV
XegXO7U6dn0pJ2GnBTQz5vX30YBQzhDijpwh5Oeot3+mV9Z00OYS2rDxPuHIYlYA
eR/SfhzWc2ATdAVbiuLzM95Y9onf6cOazsakhthwuMss0LNIBy2jrym9oqufoRDl
Q65v3uDnTRWNaVxLup9daWAxwq8tUtQ0cGBVLFPKCFAORDCFGXUhkH4tIzWnWoeB
Zhl14y7sNfMrabmG2xweNy/4GVXFFcI8V/rOHtkgqdpmhYqJYCOnbNfL1We1gnsO
ls6Zi6Qfs9bKz1vbpqAxRr6IfKUE+XKKMLZ28QS7n6bKo8FmTrRP46e2tOng89el
fnRODKVtpszSCXGgckG8+2DI5blAzhQx2fVYBfeiFb73LnlbIxZY9daetCX2xnv1
DIouag8kTy7ulw5cGkEnk28uCFH/BFvTgM9eMutG+oTlX6Y+khgUWsZcP3BeGNay
AwhULqjEYfnkshLZmAu2jUwnsd8wQ9YbrOTH80gayzVfFt3tk4y9QWJ5jaXvNZZU
OzVoADfJ1zr+0DZ6SO9tFaM6QhsDZy2Z0aqjoJ+qKpmwOGioOz7Fjq0nQiQ56TlN
EAwZs3cak73afcg7kEulnybOiLj26gM2JWVmUMtWJZyURO2av0J+9q9he6LgK09s
iyKTi62JAhwEEAEKAAYFAlOBIDAACgkQXXDS68rSyea5Rw//WRbJ+gCoi3UMVj45
368vkdjUgwobra31zdNN9/uV75C04bt++7QgcVkemyKJi6Y6+FIMEGjQF/LdoMcX
Xe6X6FxN8PO4Z29sM2iZr4Y7pxxbRmsWMPd5JWtSc72dPXaxOqtaXn78bLBy4fyG
18DqkvrQaCS3KalwxuL+W9O0U1bUNx+jjbd/1th0SQ3vX4/VR9Pn3htsZRByUi6B
4IsewYr8Yg320CgE6lrpv3xTbxwfGzp6hZpNG7V+EBb0wI/gm6Pt3g6988Duj1ch
GtDNwoWJymZGLRVF7vMHhu1sgyJ7yOEytSbWZ7PXc9JUHwsHf9uK/G0OCpgHL4H1
XZ01CNgTv5pPSDwlWahevxZ3J8/XzAP2itZSjCkEGPhH5GClH9LxB8yVkkx8ciQC
FIBgjBoBwnh1uho0YAS0qxLtp4f/otRQYhS5R5MmYVKfSju/SEPQ9QZ3pnff+/kl
Hh/l6xpnBl3fxJKOPuU5u3N2CRAvmwJ3veBMuFmbnXUOM1qyeUmlE6op4H0tAJQ4
3jre9fpBYtce0PvaBobgbxJEhRQeO3u931ShVTCqhXY3llGGgOaD4tpSmcfPXN1u
ZVmsTpYcEOrEHUncLT0dBtXzbYQkBb8JEOs31jR+G5xY3dMVDpkb5RdRJZwmDvPH
JRgHS04w1Qs28L5euSJqGa3Gyla5AQ0ESqDtkAEIANrisUkUiqXdiTtTg1A7saaW
GnGNSZHpsQ1BBxt9XKglU7hc+GpTcpeCPvKZrV9ovmB+1vXsO7hoI0czxI0zpvP2
c9rnvnkHq6L3rqNIchWvWNwsYTTAhNxB+ALn3aH7gpp1H/1u088iL83nK8BT5cmY
alp5sRKrvBWkfo1yvSbMdmW8vxIoTaAsEDlrXb9yODouSgW4JcX8ROz5mIKPQ2Kk
5h8ZrJz4lBOBWGRtuty5dWapG8Fu+58AxJdbofrY2zrvmNXCsHnFm8lSLmNXijp8
1QvPJXVUiscyjhrt+zMuM+uRkwcjEHzAZ6GfhWRRmIgok4Y/nPIvdwyEc2HjrI0A
EQEAAYkCRAQYAQIADwIbAgUCUD4zcwUJCV+s4QEpwF0gBBkBAgAGBQJKoO2QAAoJ
EHSpQbohnsgQtBEH+QH/xtP9sc9EMB+fDegsf2aDHLT28YpvhfjLWVrYmXRiextc
BRiCwLT6khulhA2vk4Tnh22dbhr87hUtuCJZGR5Y4E2ZS99KfAxXcu96Wo6Ki0X6
65G/QyUxoFYT9msYZzlv0OmbuIaED0p9lRlTlZrsDG969a/d30G8NG0Mv6CH/Sfq
tq26eP3ITqHXe1zFveVTMIliBHaWGg9JqHiu/mm2MwUxuQAzLmaCtma5LXkGTUHs
UruIdHplnqy7DHb3DC8mIjnVj9dvPrNXv54mxxhTwHkT5EPjFTzGZa6oFavYt+Fz
wPR67cVQXfz7jh6GktcqxrgA7KUmUwuaJ+DzGkIJEO6MvJ6Ibd2J/jcH/2y32VvU
VKgkAJsNS+UC3zGG9xgCBasf4d+MtzAU6BM16p30hJGRjNYmbSIDtYt6FThlZWhm
hPsECoYOsyWeqEzmfv7n0Tv8XZnxh2XZQH1BGrv2Ii5JxJRFDQEHVDbjAfU1LZgb
4dNGmKDo80aAHp7U0vv96d/okFyvDTyY0FgTU6FFVEImA/WwQiCv2h4QYZnRHNGH
3FskIHeiC++eOwUSWzw47jsgH0Viyde7iTBmKjhU5KbrZqRvJ9HRtMlHFCODKAPF
O/YhvNxAHeb00tXiYk5nPjywZ3pJ74gRAYkkTuGLuauEMZLDqmIRWAczo+h18ICQ
nM1RGVAp7lu5B8M=
=7mL8
-----END PGP PUBLIC KEY BLOCK-----
EOF
    
fpf_url="[arch=amd64] http://apt.pressfreedomfoundation.org/"
cat > fpf_signing_key << EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

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
lgWUsYZR/3tTHx0aqcH80tQ=
=gw8n
-----END PGP PUBLIC KEY BLOCK-----
EOF

add_signing_key tor_signing_key
add_signing_key fpf_signing_key
add_repo tor "$tor_url"
add_repo fpf "$fpf_url"
apt-get update
