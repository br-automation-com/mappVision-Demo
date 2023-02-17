/* Automation Studio generated header file */
/* Do not edit ! */
/* MTLinAlg 5.20.0 */

#ifndef _MTLINALG_
#define _MTLINALG_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _MTLinAlg_VERSION
#define _MTLinAlg_VERSION 5.20.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Constants */
#ifdef _REPLACE_CONST
 #define mtACD_ERR_WRONG_DIM (-1058011124)
 #define mtACD_ERR_NULL_PRT (-1058011123)
 #define mtACD_ERR_NOT_INVERTIBLE (-1058011122)
 #define mtACD_ERR_EQUATION_NOT_SOLVABLE (-1058011121)
#else
 _GLOBAL_CONST signed long mtACD_ERR_WRONG_DIM;
 _GLOBAL_CONST signed long mtACD_ERR_NULL_PRT;
 _GLOBAL_CONST signed long mtACD_ERR_NOT_INVERTIBLE;
 _GLOBAL_CONST signed long mtACD_ERR_EQUATION_NOT_SOLVABLE;
#endif




/* Datatypes and datatypes of function blocks */
typedef struct MTLinAlgMatrixType
{	double* Handle;
	unsigned short Rows;
	unsigned short Columns;
} MTLinAlgMatrixType;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC signed long MTLinAlgMatrixAddition(struct MTLinAlgMatrixType* Matrix1, struct MTLinAlgMatrixType* Matrix2, struct MTLinAlgMatrixType* Result);
_BUR_PUBLIC signed long MTLinAlgSolveEquation(struct MTLinAlgMatrixType* Matrix, struct MTLinAlgMatrixType* Vector, struct MTLinAlgMatrixType* Result);
_BUR_PUBLIC signed long MTLinAlgMatrixInverse(struct MTLinAlgMatrixType* Matrix, struct MTLinAlgMatrixType* Result);
_BUR_PUBLIC signed long MTLinAlgMatrixMultiplication(struct MTLinAlgMatrixType* Matrix1, struct MTLinAlgMatrixType* Matrix2, struct MTLinAlgMatrixType* Result);
_BUR_PUBLIC signed long MTLinAlgMatrixSubtraction(struct MTLinAlgMatrixType* Matrix1, struct MTLinAlgMatrixType* Matrix2, struct MTLinAlgMatrixType* Result);


#ifdef __cplusplus
};
#endif
#endif /* _MTLINALG_ */

