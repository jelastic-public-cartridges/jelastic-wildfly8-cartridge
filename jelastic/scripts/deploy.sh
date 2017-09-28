#!/bin/bash

# Simple deploy and undeploy scenarios for jbossas7

WGET=$(which wget);

source /etc/jelastic/environment

function ensureFileCanBeDownloaded(){
    local resource_url=$1;
    resource_data_dize=$($CURL -s --head $resource_url | $GREP "Content-Length" | $AWK -F ":" '{ print $2 }'| $SED 's/[^0-9]//g');
    freebytesleft=$(( 1024 *  $(df  | $GREP "/$" | $AWK '{ print $4 }' | head -n 1)-1024*1024));
    [ -z ${resource_data_dize} ] && return 0;
    [ ${resource_data_dize} -lt  ${freebytesleft} ] || { writeJSONResponseErr "result=>4075" "message=>No free diskspace"; die -q; }
    return 0;
}

function getPackageName() {
    if [ -f "$package_url" ]; then
        package_name=$(basename "${package_url}")
        package_path=$(dirname "${package_url}")
    elif [[ "${package_url}" =~ file://* ]]; then
        package_name=$(basename "${package_url:7}")
        package_path=$(dirname "${package_url:7}")
        [ -f "${package_path}/${package_name}" ] || { writeJSONResponseErr "result=>4078" "message=>Error loading file from URL"; die -q; }
    else
        ensureFileCanBeDownloaded $package_url;
        $WGET --no-check-certificate --content-disposition --directory-prefix="${download_dir}" $package_url >> $ACTIONS_LOG 2>&1 || { writeJSONResponseErr "result=>4078" "message=>Error loading file from URL"; die -q; }
        package_name="$(ls ${download_dir})";
        package_path=${download_dir};
        [ ! -s "${package_path}/${package_name}" ] && {
            set -f
            rm -f "${package_name}";
            set +f
            writeJSONResponseErr "result=>4078" "message=>Error loading file from URL";
            die -q;
        }
    fi
}

function _deploy(){
     [ "x${context}" == "xroot" ] && context="ROOT";
     [ -f "${WEBROOT}/${context}.war" ] && rm -f ${WEBROOT}/${context}.war;
     [ -f "${WEBROOT}/${context}.ear" ] && rm -f ${WEBROOT}/${context}.ear;
     [ -f "${WEBROOT}/${context}.war.undeployed" ] && mv ${WEBROOT}/${context}.war.undeployed ${WEBROOT}/${context}.war.deployed
     [ -f "${WEBROOT}/${context}.ear.undeployed" ] && mv ${WEBROOT}/${context}.ear.undeployed ${WEBROOT}/${context}.ear.deployed
     download_dir=$(mktemp -d)
     getPackageName
     set +f;
     chown jelastic:jelastic "${package_path}/${package_name}"
     [[ "${package_path}/${package_name}" =~ (.*.ear) ]] && cp -f "${package_path}/${package_name}" ${WEBROOT}/"${context}.ear" || cp -f "${package_path}/${package_name}" ${WEBROOT}/"${context}.war"
     rm -rf ${download_dir}
     chown -R jelastic:jelastic "${WEBROOT}"
     set -f;
}

function _undeploy(){
     [ "x${context}" == "xroot" ] && context="ROOT";
     set +f;
     rm -rf "${WEBROOT}/${context}.war" "${WEBROOT}/${context}.war.*" 1>/dev/null;
     rm -rf "${WEBROOT}/${context}.ear" "${WEBROOT}/${context}.ear.*" 1>/dev/null;
     set -f;
}
