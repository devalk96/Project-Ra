rule train_test_split:
    input:
        config["dataset_dir"] + "dataset/full_classification.npy"
    output:
        config["dataset_dir"] + "dataset/train.h5py"
    threads:
        1
    message:
        "Splitting training data into test and train dataset"
    log:
        config["results_dir"] + "logs/train_test_split/train_test_split.log"
    benchmark:
        config["results_dir"] + "benchmarks/train_test_split/train_test_split.benchmark.txt"
    script:
        "../scripts/machine_learning/train_test_split.py"

rule sgd_classifier:
    input:
        config["dataset_dir"] + "dataset/train.h5py"
    output:
        model=config["results_dir"] + "models/SGD.sav",
        metrics=config["results_dir"] + "model_metrics/SGD.sav",
        report=config["results_dir"] + "model_metrics/SGD_report.sav"
    threads:
        1
    message:
        "Training SGD classifier"
    log:
        config["results_dir"] + "logs/models/sgd_classifier.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/sgd_classifier.benchmark.txt"
    script:
        "../scripts/machine_learning/sgd_classifier.py"

rule sgd_classifier_manual:
    input:
        config["dataset_dir"] + "dataset/train.h5py"
    output:
        model=config["results_dir"] + "models/SGDmanual.sav",
        metrics=config["results_dir"] + "model_metrics/SGDmanual.sav",
        report=config["results_dir"] + "model_metrics/SGDmanual_report.sav"
    threads:
        1
    message:
        "Training SGD classifier"
    log:
        config["results_dir"] + "logs/models/sgd_manual_classifier.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/sgd_manual_classifier.benchmark.txt"
    script:
        "../scripts/machine_learning/sgd_classifier_manual.py"

rule gaussian_nb:
    input:
        config["dataset_dir"] + "dataset/train.h5py"
    output:
        model=config["results_dir"] + "models/GaussianNB.sav",
        metrics=config["results_dir"] + "model_metrics/GaussianNB.sav",
        report=config["results_dir"] + "model_metrics/GaussianNB_report.sav"
    threads:
        1
    message:
        "Training Gaussian Naive Bayes classifier"
    log:
        config["results_dir"] + "logs/models/gaussian_nb.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/gaussian_nb.benchmark.txt"
    script:
        "../scripts/machine_learning/gaussiannb.py"

rule zero_r:
    input:
        config["dataset_dir"] + "dataset/train.h5py"
    output:
        model=config["results_dir"] + "models/ZeroR.sav",
        metrics=config["results_dir"] + "model_metrics/ZeroR.sav",
        report=config["results_dir"] + "model_metrics/ZeroR_report.sav"
    threads:
        1
    message:
        "Training ZeroR classifier"
    log:
        config["results_dir"] + "logs/models/zero_r.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/zero_r.benchmark.txt"
    script:
        "../scripts/machine_learning/zero_r.py"

rule multinomial_nb:
    input:
        config["dataset_dir"] + "dataset/train.h5py"
    output:
        model=config["results_dir"] + "models/MultinomialNB.sav",
        metrics=config["results_dir"] + "model_metrics/MultinomialNB.sav",
        report=config["results_dir"] + "model_metrics/MultinomialNB_report.sav"
    threads:
        1
    message:
        "Training Multinomial Naive Bayes classifier"
    log:
        config["results_dir"] + "logs/models/multinomial_nb.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/multinomial_nb.benchmark.txt"
    script:
        "../scripts/machine_learning/multinomialnb.py"

rule decision_tree:
    input:
        config["dataset_dir"] + "dataset/train.h5py"
    output:
        model=config["results_dir"] + "models/DecisionTree.sav",
        metrics=config["results_dir"] + "model_metrics/DecisionTree.sav",
        report=config["results_dir"] + "model_metrics/DecisionTree_report.sav"
    threads:
        1
    message:
        "Training Decision Tree classifier"
    log:
        config["results_dir"] + "logs/models/DecisionTree.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/DecisionTree.benchmark.txt"
    script:
        "../scripts/machine_learning/decisiontree.py"

rule SVM:
    input:
        config["dataset_dir"] + "dataset/train.h5py"
    output:
        model=config["results_dir"] + "models/SVM.sav",
        metrics=config["results_dir"] + "model_metrics/SVM.sav",
        report=config["results_dir"] + "model_metrics/SVM_report.sav"

    threads:
        1
    message:
        "Training SVM classifier"
    log:
        config["results_dir"] + "logs/models/SVM.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/SVM.benchmark.txt"
    script:
        "../scripts/machine_learning/SVM.py"

rule SVM_sampling:
    input:
        config["dataset_dir"] + "dataset/full_classification.npy"
    output:
        model=config["results_dir"] + "models/SVMsampling.sav",
        metrics=config["results_dir"] + "model_metrics/SVMsampling.sav",
        report=config["results_dir"] + "model_metrics/SVMsampling_report.sav"
    threads:
        1
    message:
        "Training SVM_sampling classifier"
    log:
        config["results_dir"] + "logs/models/SVMsampling.log"
    benchmark:
        config["results_dir"] + "benchmarks/models/SVMsampling.benchmark.txt"
    script:
        "../scripts/machine_learning/SVM_sampling.py"

# rule Kernel:
#     input:
#         config["dataset_dir"] + "dataset/train.h5py"
#     output:
#         model=config["results_dir"] + "models/Kernel.sav",
#         metrics=config["results_dir"] + "model_metrics/Kernel.sav"
#     threads:
#         1
#     message:
#         "Training SVM classifier"
#     log:
#         config["results_dir"] + "logs/models/Kernel.log"
#     benchmark:
#         config["results_dir"] + "benchmarks/models/Kernel.benchmark.txt"
#     script:
#         "../scripts/machine_learning/kernel_approximation.py"
