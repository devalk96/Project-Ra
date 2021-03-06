rule combine_features_data:
    input:
        windows = config["dataset_dir"] + "data_subset/{image}_windows.npy",
        gaussian = config["dataset_dir"] + "data_subset/{image}_gaussian.npy",
        edges = config["dataset_dir"] + "data_subset/{image}_edges.npy"
    output:
        config["dataset_dir"] + "dataset/total_features_{image}.npy"
    params:
        temp_file=config["dataset_dir"] + "dataset/temp_total_features_{image}.npy"
    threads:
        1
    message:
        "Combining feature datasets for {wildcards.image}"
    log:
        config["results_dir"] + "logs/combine_features_data/{image}.log"
    benchmark:
        config["results_dir"] + "benchmarks/combine_features_data/{image}.benchmark.txt"
    script:
        "../scripts/dataset_building/array_builder.py"

rule add_classifier:
    input:
        features = config["dataset_dir"] + "dataset/total_features_train_data.npy",
        classifier = config["dataset_dir"] + "classifiers/full_classifier.npy"
    output:
        config["dataset_dir"] + "dataset/full_classification.npy"
    params:
        temp_file= config["dataset_dir"] + "classifiers/temp_full_classification.npy"
    threads:
        1
    message:
        "Adding classifier to training features dataset"
    log:
        config["results_dir"] + "logs/add_classifier/add_classifier.log"
    benchmark:
        config["results_dir"] + "benchmarks/add_classifier/add_classifier.benchmark.txt"
    script:
        "../scripts/dataset_building/array_builder.py"