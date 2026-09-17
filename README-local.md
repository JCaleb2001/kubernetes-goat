# Notas del lab local (WSL2 Ubuntu, sin Docker Desktop)

Este fork corre 100% dentro de la distro Ubuntu de WSL2, con Docker Engine
(docker-ce), `kind`, `kubectl` y `helm` instalados nativamente ahi -- no se
usa Docker Desktop ni su integracion WSL, ni el Kubernetes propio de Docker
Desktop.

## Comandos rapidos

```bash
make up       # crea el cluster kind (si no existe), despliega el lab y expone el acceso
make status   # kubectl get pods -A
make access   # relanza solo los port-forwards (si el cluster ya esta desplegado)
make down     # teardown de escenarios + borra el cluster kind
make reset    # down + up, para volver a un estado limpio entre ejercicios
```

Tambien se puede usar directamente `bash wsl-quickstart.sh` / `bash lab-reset.sh`.

## Arranque del daemon Docker

Esta distro tiene `systemd` activo (`/etc/wsl.conf` con `systemd=true`), asi
que Docker se gestiona con:

```bash
sudo systemctl status docker
sudo systemctl enable --now docker   # si no esta corriendo
```

Si tu distro NO tuviera systemd, la alternativa es `sudo service docker start`
en cada sesion.

## Puertos expuestos por `access-kubernetes-goat.sh`

| Puerto | Escenario |
|---|---|
| 1230-1233 | build-code, health-check, internal-proxy, system-monitor |
| 1234 | kubernetes-goat-home (pagina de inicio) |
| 1235 | poor-registry |
| 1236 | hunger-check (namespace `big-monolith`) |

`http://127.0.0.1:1234` es accesible tanto desde dentro de WSL como desde
Windows (localhost forwarding automatico de WSL2), sin configuracion extra.

## Persistencia de los port-forwards

Los port-forwards de `access-kubernetes-goat.sh` se lanzan en background con
`&` (sin `nohup`/`setsid`). Si `systemd-logind` cierra tu ultima sesion de
usuario y no tienes "lingering" habilitado, esos procesos pueden morir. Para
que sobrevivan de forma independiente de cualquier terminal abierta:

```bash
sudo loginctl enable-linger $USER
```

Es un cambio de sistema estandar y de bajo riesgo (solo evita que se maten
los procesos del usuario al no haber sesiones activas), no afecta al
comportamiento vulnerable-a-proposito del lab.

## Bug upstream documentado (por si reaparece en un `git pull` de upstream)

`platforms/kind-setup/setup-kind-cluster-and-goat.sh` invocaba
`sh setup-kubernetes-goat.sh`, pero ese script usa sintaxis bash
(`[[ ]]`, `case ... shift 2`). En Ubuntu/WSL2 `/bin/sh` es `dash`, que no
soporta esa sintaxis, asi que el script "todo en uno" fallaba tal cual venia
de upstream. Ya esta corregido en este fork (usa `bash` explicitamente). Si
haces `git merge upstream/master` y el problema vuelve, hay que reaplicar el
cambio.

## Alcance de las mejoras de este fork

Solo ergonomia/reproducibilidad del lab (scripts de conveniencia, Makefile,
este README, el fix de `sh`/`bash`). **No** se toco RBAC, Dockerfiles
vulnerables ni manifiestos de `scenarios/*` -- eso romperia el proposito
educativo del proyecto.

## Documentacion del lab

La guia propia (teoria + comandos + walkthrough en espanol) esta en
[`docs-local/`](docs-local/README.md).
