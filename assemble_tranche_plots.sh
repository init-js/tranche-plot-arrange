#!/usr/bin/env bash

set -exo pipefail

setdir=/project/rpp-rbruskie/jslegare/snps/cohorts/
suppdir=$(readlink -f "$(dirname "$0")")/supplement/

sets=(
    all_ann1
    all_arg1
    all_pet
)

declare -A xtitle=( ["all_ann1"]="H. annuus"
		    ["all_arg1"]="H. argophyllus"
		    ["all_pet"]="H. petiolaris"
		  )

function extract_plots () {
    local cohort="$1"
    local dir="$2"
    
    for snp_model in "$setdir/$cohort/vcf/partial_variant_model_snps_"*".tgz"; do :; done
    [[ -f "$snp_model" ]]
    tar -xzvf "$snp_model" -C "$dir" --exclude "*.vcf.*"
}

for x in "${sets[@]}"; do

    plotdir=plot_$x
    
    if [[ ! -d "$plotdir" ]]; then
	tmpdir=$(mktemp -d -p . tmp_plot_$x.XXXXXX)
	extract_plots "$x" "$tmpdir"
	mv -v "$tmpdir" "$plotdir"
    fi

    # overwrite with default.
    cp {"$suppdir","$plotdir"}/plot_Tranches.R

    ln -sfT snp.tranches "$plotdir"/"$x.tranches"
    ( cd "$plotdir" && XTITLE="${xtitle[$x]}" Rscript plot_Tranches.R "$x.tranches" 2.15; echo $?; )
    
done


#snp.recal.Rscript
#snp.recal.Rscript.pdf
#snp.recal.vcf.gz
#snp.recal.vcf.gz.tbi
#snp.tranches
#snp.tranches.pdf
#plot_Tranches.R
