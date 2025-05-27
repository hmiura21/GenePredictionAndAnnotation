# 🧬 Bacterial Genome Annotation 

---

## 📄 Assignment Summary

This repository documents the steps taken to annotate a bacterial genome and extract key sequences using bioinformatics tools, in line with the January 2025 genome study that describes *GCF_037966535.1*, which contains two rRNA operons.

---

## 📦 Tools Used

| Step | Tool | Notes |
|------|------|-------|
| CDS Prediction | **Prodigal** | Chosen from available options (GeneMark, Glimmer, Prodigal) |
| rRNA Prediction | **barrnap** | Chosen over RNAmmer (no manuscript exists for barrnap) |
| Alignment | **NCBI BLAST (web GUI)** | Used for 16S rRNA species-level identification |

---

## 🧪 Workflow

Each step below corresponds to a task in the assignment. Shell commands for all steps are documented in `cmds.sh`

### 1. ✅ Download Genome Assembly
- Downloaded *GCF_037966535.1* (RefSeq assembly).
- Verified presence of 2 rRNA operons as reported in Table 1 of the associated 2025 publication.

### 2. 🔍 Predict CDS with Prodigal
- Ran Prodigal to predict all coding sequences.


### 3. 🧬 Predict rRNA Genes with barrnap
- Ran `barrnap` on the assembly FASTA to extract rRNA features.
- Extracted all **16S rRNA sequences** and saved them in a **compressed FASTA**:

### 4. 🌍 Identify Top 5 16S rRNA Matches
- Uploaded extracted 16S rRNA FASTA to **NCBI BLAST web GUI**
- Sorted by best E-value, % identity, and query coverage.

---

## 📁 Files Included

| File | Description |
|------|-------------|
| `cmds.sh` | All shell commands used during this project |
| `16S.fa` | 6S sequence file |
| `cds.gff.gz` | CDS prediction file |
| `cds.log.gz` | CDS prediction logfile |
| `top_ssu_alignments.xlsx` |16S blast results file  |

---

