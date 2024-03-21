# Practical_Project
Repository for my practical project investiagting Theoretical plausibility of P300 latency across offline reference schemes, electrode groups and single trial algorithms.

Here you can find all the scripts I used for my practical project. 
Additionally, you can have a look at my poster, abstract and an additional plot of the ERPs in the 4 conditions and across the quantification decisions.

Abstract:
Multiverse Analysis for Transparent and Replicable Neurometric Evaluations: Theoretical Plausibility of P300 Estimates Across Single Trial EEG Algorithms and Quantification Decisions

Student Name: Rosina Zollner
Supervisor(s): Cassie Ann Short

More than 70% of researchers who have attempted to replicate experiments conducted by other scientists have failed, a phenomenon known as the Replication Crisis. One factor contributing to this issue are the researchers’ degrees of freedom, encompassing the numerous decisions a researcher makes throughout the analysis process. Multiverse analysis is a common approach used to investigate the robustness of an effect across various defensible analysis pipelines and to report the data processing uncertainty created by the researchers’ degrees of freedom.
In this study, we performed a 4x4x4 exploratory multiverse analysis with three decision knots: reference schemes, electrode groups and single-trial algorithms (peak-picking, template matching, maximum likelihood estimation (MLE), and residue iteration decomposition (RIDE)). We reused a previously preprocessed EEG dataset (167 participants, 4 conditions: face-easy vs. difficult, house-easy vs. difficult). The robustness of the theoretical plausibility, i.e. correlation of reaction time and latency estimates of P300 component, was tested across the resulting 64 pipelines. 
The overall theoretical plausibility was low. Results didn’t show a pattern in reference scheme and electrode group. However, a pattern was found in the single-trial algorithms. In almost all conditions, RIDE and Template Matching led to consistently higher theoretical plausibility than Peak-Picking and MLE. This aligns with Ouyang et al.’s (2017) findings. In the house-difficult condition, RIDE led to the lowest theoretical plausibility. This could be due to subjective differences in task difficulty to the face-difficult condition.
In future, it could be interesting to include more preprocessing steps and to test robustness across several ERP components.



