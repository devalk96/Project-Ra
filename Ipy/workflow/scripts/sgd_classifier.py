#!usr/bin/env python3

"""
Script to run SGDClassifier on a given dataset making use of bayesian hyperparameter tuning
"""

__author__ = "Skippybal"
__version__ = "0.1"

import pickle
import numpy as np
import sys
from sklearn.linear_model import SGDClassifier
from scipy.stats import uniform, loguniform
from sklearn import metrics
from skopt.space import Real, Integer, Categorical
from skopt.utils import use_named_args
from skopt import gp_minimize
import h5py


def batch_generator(instances, ys, batch_size):
    for i in range(0, len(instances), batch_size):
        yield instances[i:i+batch_size], ys[i:i+batch_size]


def validation_generator(instances, batch_size):
    for i in range(0, len(instances), batch_size):
        yield instances[i:i + batch_size]


def find_optimal(x_train, x_val, y_train, y_val, classes):
    #model = SGDClassifier(loss='log')  # shuffle=True is useless here
    #model = SGDClassifier(tol=1e-3, penalty='elasticnet', random_state=0)

    # params = {'alpha': loguniform(1e-2, 1e0),
    #           'l1_ratio': uniform(0, 1)}

    space = [Real(10 ** -5, 10 ** 0, "log-uniform", name='alpha'),
             Real(0, 1, name='l1_ratio'),
             Categorical(['hinge', 'log', 'modified_huber', 'squared_hinge'], name='loss')
             ]

    @use_named_args(space)
    def objective(**params):
        #model = SGDClassifier(tol=1e-3, penalty='elasticnet', random_state=0)
        model = SGDClassifier(random_state=0)
        model.set_params(**params)

        n_iter = 1
        for n in range(n_iter):
            print(n)

            for mini_batch_x, mini_batch_y in batch_generator(x_train, y_train, 50000):
                #print(np.unique(y_train))
                # with parallel_backend('threading', n_jobs=-1):
                model.partial_fit(mini_batch_x, mini_batch_y,
                                  classes=classes)

        y_pred = []
        for val_batch in validation_generator(x_val, 50000):
            y_pred.extend(model.predict(val_batch))
        accurary = metrics.accuracy_score(y_val, y_pred)
        loss = 1 - accurary
        print("Accuracy: ", accurary)
        unique = np.unique(y_pred)
        if len(unique) == 1:
            print("Accuracy set to 0, so loss == 1")
            return 1

        return loss


    # filename = f'/homes/kanotebomer/Documents/Thema11/Project-Ra/scripts/machine_learning/models/SGD_mit.sav'
    # pickle.dump(model, open(filename, 'wb'))

    res_gp = gp_minimize(objective, space, n_calls=10, random_state=0)
    print(res_gp.fun)
    print(res_gp.x)

    optimal_params = {'alpha': res_gp.x[0],
                      'l1_ratio': res_gp.x[1],
                      'loss': res_gp.x[2]}
    print(optimal_params)
    return optimal_params


def train_sgd(x_train, x_val, y_train, y_val, classes, optimal_params, save_loc, metric_loc):
    model = SGDClassifier(random_state=0,
                          alpha=optimal_params["alpha"], l1_ratio=optimal_params["l1_ratio"], loss=optimal_params["loss"])

    n_iter = 10
    for n in range(n_iter):
        print(n)

        for mini_batch_x, mini_batch_y in batch_generator(x_train, y_train, 10000):
            # with parallel_backend('threading', n_jobs=-1):
            model.partial_fit(mini_batch_x, mini_batch_y,
                              classes=classes)

    pickle.dump(model, open(save_loc, 'wb'))

    y_pred = []
    for val_batch in validation_generator(x_val, 10000):
        y_pred.extend(model.predict(val_batch))

    metric_dict = {"Model": "SGDClassifier"}
    accuracy = metrics.accuracy_score(y_val, y_pred)
    metric_dict["Accuracy"] = accuracy
    pickle.dump(metric_dict, open(metric_loc, 'wb'))

    print("Accuracy: ", accuracy)

    return 0


def main():
    #model = SGDClassifier(tol=1e-3, penalty='elasticnet', random_state=0)
    hdf5_file = snakemake.input[0]
    save_location = snakemake.output["model"]
    metric_loc = snakemake.output["metrics"]

    f = h5py.File(hdf5_file, 'r')
    x_train = f.get('x_train')
    y_train = f.get('y_train')
    x_val = f.get('x_test')
    y_val = f.get('y_test')
    classes = np.unique(y_train)
    #print(x_val.shape)
    #print(classes)
    optimal_params = find_optimal(x_train, x_val, y_train, y_val, classes)
    train_sgd(x_train, x_val, y_train, y_val, classes, optimal_params, save_location, metric_loc)

    f.close()

    return 0


if __name__ == '__main__':
    with open(snakemake.log[0], "w") as log_file:
        sys.stderr = sys.stdout = log_file
        exitcode = main()
        sys.exit(exitcode)
