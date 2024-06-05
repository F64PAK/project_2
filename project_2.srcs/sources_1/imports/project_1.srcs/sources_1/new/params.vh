`include "sha256_offsets.h"
/* Hash output length in bytes. */
parameter SPX_N = 16;
/* Height of the hypertree. */
parameter SPX_FULL_HEIGHT = 66;
/* Number of subtree layer. */
parameter SPX_D 22;
/* FORS tree dimensions. */
parameter SPX_FORS_HEIGHT = 6;
parameter SPX_FORS_TREES = 33;
/* Winternitz parameter, */
parameter SPX_WOTS_W = 16;

/* The hash function is defined by linking a different hash.c file, as opposed
   to setting a #define constant. */

/* For clarity */
parameter SPX_ADDR_BYTES = 32;

/* WOTS parameters. */
if (SPX_WOTS_W == 256)
    begin
    parameter SPX_WOTS_LOGW  = 8;
    end
else if (SPX_WOTS_W == 16)
    begin
    parameter SPX_WOTS_LOGW =4;
    end

parameter SPX_WOTS_LEN1 =  (8 * SPX_N / SPX_WOTS_LOGW);

/* SPX_WOTS_LEN2 is floor(log(len_1 * (w - 1)) / log(w)) + 1; we precompute */
if (SPX_WOTS_W == 256)
    if (SPX_N <= 1)
        parameter SPX_WOTS_LEN2 = 1;
    else if (SPX_N <= 256)
        parameter SPX_WOTS_LEN2 = 2;
else if (SPX_WOTS_W == 16)
    if (SPX_N <= 8)
        parameter SPX_WOTS_LEN2 = 2;
    else if (SPX_N <= 136)
        parameter SPX_WOTS_LEN2 = 3;
    else if SPX_N <= 256
        parameter SPX_WOTS_LEN2 = 4;
   

parameter SPX_WOTS_LEN = (SPX_WOTS_LEN1 + SPX_WOTS_LEN2);
parameter SPX_WOTS_BYTES = (SPX_WOTS_LEN * SPX_N);
parameter SPX_WOTS_PK_BYTES = SPX_WOTS_BYTES;

/* Subtree size. */
parameter SPX_TREE_HEIGHT = (SPX_FULL_HEIGHT / SPX_D);

if (SPX_TREE_HEIGHT * SPX_D != SPX_FULL_HEIGHT)
    printf("#error SPX_D should always divide SPX_FULL_HEIGHT\n")


/* FORS parameters. */
parameter SPX_FORS_MSG_BYTES = ((SPX_FORS_HEIGHT * SPX_FORS_TREES + 7) / 8);
parameter SPX_FORS_BYTES = ((SPX_FORS_HEIGHT + 1) * SPX_FORS_TREES * SPX_N);
parameter SPX_FORS_PK_BYTES = SPX_N;

/* Resulting SPX sizes. */
parameter SPX_BYTES = (SPX_N + SPX_FORS_BYTES + SPX_D * SPX_WOTS_BYTES +\
                   SPX_FULL_HEIGHT * SPX_N);
parameter SPX_PK_BYTES = (2 * SPX_N);
parameter SPX_SK_BYTES = (2 * SPX_N + SPX_PK_BYTES);

/* Optionally, signing can be made non-deterministic using optrand.
   This can help counter side-channel attacks that would benefit from
   getting a large number of traces when the signer uses the same nodes. */
parameter SPX_OPTRAND_BYTES = 32;



