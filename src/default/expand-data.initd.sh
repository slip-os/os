#!/sbin/openrc-run
# shellcheck shell=bash

depend() {
    before localmount
}

start() {
    ebegin "Expanding data filesystem"
    ret=0
    if [ ! -b ${DEVICE}${PART} ]; then
        ret=1
    fi
    if [ ${ret} -eq 0 ] && growpart --dry-run ${DEVICE} ${PART} > /dev/null 2>&1; then
        e2fsck -f ${DEVICE}${PART} && \
        growpart ${DEVICE} ${PART} && \
        resize2fs -f ${DEVICE}${PART}
        ret=$?
    fi
    eend ${ret}
}
