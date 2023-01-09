#!/bin/bash


armbian_url="${{ inputs.armbian_url }}"
if  [[ -z "${armbian_url}" ]]; then
    armbian_site="https://armbian.tnahosting.net/dl/odroidn2/archive/"
    armbian_name="Armbian.*jammy.*.img.xz"
    armbian_file=$(curl -s "${armbian_site}" | grep -oE "${armbian_name}" | head -n 1)
    if [[ -n "${armbian_file}" ]]; then
        armbian_url="${armbian_site}${armbian_file}"
    else
        echo -e "Invalid download path: [ ${armbian_site} ]"
        exit 1
    fi
fi

echo "ARMBIAN_URL=${armbian_url}" >> ${GITHUB_ENV}
# Get the release name of the rebuild armbian file
set_release="_"
ARR_RELEASE=("jammy" "focal" "bullseye" "buster" "sid")
i=1
for r in ${ARR_RELEASE[*]}; do
    if [[ "${armbian_url}" == *"${r}"* ]]; then
        set_release="_${r}_"
        break
    fi
    let i++
done
echo "ARMBIAN_RELEASE=${set_release}" >> ${GITHUB_ENV}
echo "status=success" >> ${GITHUB_OUTPUT}


