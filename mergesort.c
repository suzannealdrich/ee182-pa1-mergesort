#include <stdlib.h>

void mergesort(int *a, int lt, int rt)
{
  int i, j, k, mid;
  int *b;
  b = (int *)malloc((rt + 1) * sizeof(int));

  if ( rt > lt )
  {
    mid = (rt + lt) / 2;
    mergesort(a, lt, mid);
    mergesort(a, mid + 1, rt);

    /* Merging
     *-------------------------------------------------------
     * First copy the parts to be merged to the temporary
     * array, but copy the right part in reverse order.
     * This way the largest elements line up back-to-back,
     * thus we eliminate the need for checking if we
     * cross over from one array to the next; we never
     * will since if we do, we are pointing to a big element!
     *-------------------------------------------------------*/
    
    /* Copy the left part */
    for(i = lt; i <= mid; i++)
       b[i] = a[i];

    /* Copy the right part in reverse order */
    for(j = mid + 1; j <= rt; j++)
       b[j] = a[rt + mid + 1 - j];

    /* Merge the two arrays */
    i = lt;
    j = rt;
    for(k = lt; k <= rt; k++)
       a[k] = ( b[i] < b[j] ) ? b[i++] : b[j--];
  }
  free(b); 
  /*----------------------------------------------------------
   * When writing your assembly code, dont worry about freeing
   * memory. In other words, do not attempt to translate
   * "free(b)" when writing your mergesort routine.
   *---------------------------------------------------------*/
  
}






int main(int argc, char *argv[])
{
  int *nums;
  int i;
  int array_size;
  
  printf("How many elements to be sorted?\n");
  scanf("%d", &array_size);

  nums = (int *) malloc(sizeof(int) * array_size);

  for (i = 0; i < array_size; i++)
  {
    printf("Enter next element:\n");
    scanf("%d", &(nums[i]));
  }

  mergesort(nums, 0, array_size - 1);

  printf("The sorted list is:\n");
  for (i = 0; i < array_size; i++)
  {
    printf("%d ", nums[i]);
  }
  printf("\n");

}
