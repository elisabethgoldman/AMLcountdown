import os
import re

configfile: "config.yaml"
mapped = config["bam_dir"]

SAMPLES, = glob_wildcards(os.path.join(mapped, "{sample_id}_R1.deduplicated.bam"))

rule all:
    input: 
        expand("data/merged/{sample_id}_merged.bam", sample_id=SAMPLES)
rule merge_bams:
    input:
        r1=mapped + "/{sample_id}_R1.deduplicated.bam",
        r2=mapped + "/{sample_id}_R2.deduplicated.bam"
    output:
        merged_bam="data/merged/{sample_id}_merged.bam"
    log:
        "logs/{sample_id}_merged.log"
    conda:
        "envs/samtools.yaml"
    shell:
        """
        samtools merge {output.merged_bam} {input.r1} {input.r2} 2> {log}
        """

#rule run_multiqc:
#    input:
#        expand("data/merged/{sample_id}_merged.bam", sample_id=glob_wildcards(os.path.join(mapped, "{sample_id}_R1.deduplicated.bam")).sample_id)
#    output:
#        "multiqc_report.html"
#    log:
#        "logs/multiqc.log"
#    conda:
#        "envs/multiqc.yaml"
#    shell:
#        """
#        multiqc . --filename {output} -f 2> {log}
##        """
