process ADATA_BARCODES {

    //
    // Module from nf-core/scdownstream.
    // This module performs the subset of the h5ad file to only contain barcodes that passed emptydrops filter with cellbender
    //

    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/anndata:0.10.7--e9840a94592528c8':
        'community.wave.seqera.io/library/anndata:0.10.7--336c6c1921a0632b' }"

    input:
    tuple val(meta), path(h5ad), path(barcodes_csv)

    output:
    tuple val(meta), path("*.h5ad"), emit: h5ad
    path "versions.yml"            , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    template 'barcodes.py'

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.h5ad
    touch versions.yml
    """
}
