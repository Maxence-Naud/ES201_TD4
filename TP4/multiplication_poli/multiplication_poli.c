#define N 999

int main(int argc, char const *argv[])
{
    float pol_a[N + 1], pol_b[N + 1], pol_c[2*N + 1];
    float temp_a, temp_b;
    int i, k;

    for(i = 0; i <= N; i++){
        pol_a[i] = 1.0;
        pol_b[i] = 1.0;
        pol_c[i] = 0.;
        pol_c[N+i] = 0.;
    }

    for(i = 0; i <= 2*N; i++){
        for(k = 0; k <= i; k++){
            temp_a = (k <= N) ? pol_a[k] : 0.;
            temp_b = (i-k <= N) ? pol_b[k] : 0.;
            pol_c[i] += temp_a * temp_b;
        }
    }

    return 0;
}