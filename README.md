# Anymatrix interface to the SuiteSparse Matrix Collection

This interface to the [SuiteSparse](https://people.engr.tamu.edu/davis/suitesparse.html) [Matrix Collection](http://sparse.tamu.edu/) is a remote group for the extensible matrix collection [Anymatrix](https://github.com/mmikaitis/anymatrix).

## Usage
The repository can be added to Anymatrix with the command
```MATLAB
anymatrix('g', 'suitesparse', 'mfasi/suitesparse');
```
A few minutes will be required for it to install. The installation procedure downloads the SuiteSparse index and the files containing the singular values of the smaller matrices. The matrices themselves are downloaded automatically the first time they are used.

The interface is similar to that of the `ssget` function available in the [SuiteSparse repository](https://github.com/DrTimothyAldenDavis/SuiteSparse), but some changes were necessary in order to integrate the collection into Anymatrix.

Each SuiteSparse group is an Anymatrix group. The groups currently available in Anymatrix can be listed with the command
```MATLAB
anymatrix('g')
```
If the repository has been installed successfully, the output of this command should be a cell array that contains, among others, all the the matrix groups in SuiteSparse.

The matrices in a group can be listed with
```MATLAB
anymatrix('g', '<group_name>')
```
and a specific matrix can be generated with the command
```MATLAB
anymatrix('<group_name>/<matrix_name>')
```

### Example

A first interaction with the collection may look like this:
```MATLAB
>> % Install the interface (will take a few minutes).
>> anymatrix('g', 'suitesparse', 'mfasi/suitesparse');
Cloning into '<anymatrix_root_folder>/suitesparse/private'...
<Git output>
Anymatrix remote group cloned.
Running function setup()...done.
Automatic anymatrix scanning done.
Anymatrix scanning done.
>> format compact % Not necessary: this is just to remove empty lines.
>> % List all group currently installed.
>> anymatrix('g')
ans =
  <number_of_groups>x1 cell array
    {'ACUSIM'               }
    {'AMD'                  }
    {'ANSYS'                }
    {'ATandT'               }
    {'Alemdar'              }
    ...
    {'vanHeukelum'          }
>> % List all matrices in group `vanHeukelum`.
>> anymatrix('g', 'vanHeukelum')
ans =
  13x1 cell array
    {'vanHeukelum/cage10'}
    {'vanHeukelum/cage11'}
    {'vanHeukelum/cage12'}
    {'vanHeukelum/cage13'}
    {'vanHeukelum/cage14'}
    {'vanHeukelum/cage15'}
    {'vanHeukelum/cage3' }
    {'vanHeukelum/cage4' }
    {'vanHeukelum/cage5' }
    {'vanHeukelum/cage6' }
    {'vanHeukelum/cage7' }
    {'vanHeukelum/cage8' }
    {'vanHeukelum/cage9' }
>> % Generate matrix with ID `vanHeukelum/cage9`.
>> A = anymatrix('vanHeukelum/cage9');
>> size(A)
ans =
        3534        3534
```


## References

[1] Scott Kolodziej, Mohsen Aznaveh, Matthew Bullock, Jarrett David, Timothy A. Davis, Matthew Henderson, Yifan Hu, and Read Sandstrom, [The SuiteSparse Matrix Collection Website Interface](https://doi.org/10.21105/joss.01244), Journal of Open Source Software, 4(35), 1244, March 2019.

[2] Timothy A. Davis, Yifan Hu, [The University of Florida Sparse Matrix Collection](https://doi.org/10.1145/2049662.2049663), ACM Transactions on Mathematical Software, 38(1), pp. 1:1-1:25, December 2011.


## License

This software is distributed under the terms of the [BSD 2-clause license](LICENSE.md).
