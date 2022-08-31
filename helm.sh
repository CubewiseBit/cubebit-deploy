#!/bin/bash

PROG_NAME=$0
ACTION=$1
APP=$2

usage() {
    echo "Usage: $PROG_NAME {install|uninstall|upgrade|rollback|validate|get|history} {app}"
    exit 2 # bad usage
}

if [ "$UID" -eq 0 ]; then
    echo "ERROR: can't run as root, please use: sudo -u admin $0 $@"
    exit 3 # bad user
fi

if [ $# -lt 2 ]; then
    usage
    exit 2 # bad usage
fi

install() {
    helm install -f ./$APP/k8s/helm/user-defined-values.yaml $APP ./$APP/k8s/helm
}

uninstall() {
    helm uninstall $APP
}

upgrade() {
    helm upgrade -f ./$APP/k8s/helm/user-defined-values.yaml $APP ./$APP/k8s/helm
}

rollback() {
    helm rollback $APP
}

validate() {
    helm install -f ./$APP/k8s/helm/user-defined-values.yaml $APP ./$APP/k8s/helm --debug --dry-run
}

get() {
    helm get all $APP
}

history() {
    helm history $APP
}

status() {
    helm status $APP
}

main() {
    now=`date "+%Y-%m-%d %H:%M:%S"`
    echo "-------------$now-------------"

    case "$ACTION" in
        install)
            install
        ;;
        uninstall)
            uninstall
        ;;
        upgrade)
            upgrade
        ;;
        rollback)
            rollback
        ;;
        validate)
            validate
        ;;
        get)
            get
        ;;
        history)
            history
        ;;
        status)
            status
        ;;
        *)
            usage
        ;;
    esac
}

main;