# Anymatrix interface to the SuiteSparse Matrix Collection

This interface to the [SuiteSparse](https://people.engr.tamu.edu/davis/suitesparse.html) [Matrix Collection](http://sparse.tamu.edu/) is a remote group for the extensible matrix collection [Anymatrix](https://github.com/mmikaitis/anymatrix).

## Usage
The repository can be added to Anymatrix with the command
```
anymatrix('g', 'suitesparse', 'mfasi/suitesparse');
```
A few minutes will be required for it to install. The installation procedure downloads the SuiteSparse index and the files containing the singular values of the smaller matrices. The matrices themselves are downloaded automatically the first time they are used.

The interface is similar to that of the `ssget` function available in the [SuiteSparse repository](https://github.com/DrTimothyAldenDavis/SuiteSparse), but some changes were necessary in order to integrate the collection into Anymatrix.

Each SuiteSparse group is an Anymatrix group. The groups currently available in Anymatrix can be listed with the command
```
anymatrix('g')
```
The list should contain all the SuiteSparse groups if the repository has been installed successfully.

The matrices in a group can be listed with
```
anymatrix('g', '<group_name>')
```
and a specific matrix can be generated with the command
```
anymatrix('<group_name>/<matrix_name>')
```
