# Status Updates
General log of work

## 29 Aug 2026
### OLLAMA startup failure
In the past, we've been able to serve ollama & run queries in VSCode. We've even been able to spin up an openUI GUI & run the model through there.

Today, the prompts are all failing. THe response is 
```
time=2026-08-29T11:42:19.655-04:00 level=ERROR source=sched.go:489 msg="error loading llama server" error="llama runner process has terminated: error:CHECK_TRY_ERROR(op(ctx, src0, src1, dst, src0_dd_i, src1_ddf_i, src1_ddq_i, dst_dd_i, dev[i].row_low, dev[i].row_high, src1_ncols, src1_padded_col_size, stream)): Exception caught in this line of code.\n  in function ggml_sycl_op_mul_mat at /home/runner/_work/llm.cpp/llm.cpp/ollama-llama-cpp/ggml/src/ggml-sycl/ggml-sycl.cpp:2876\n/home/runner/_work/llm.cpp/llm.cpp/ollama-llama-cpp/ggml/src/ggml-sycl/../ggml-sycl/common.hpp:115: SYCL error"
```

### Git sync failure
Had troubles with the git push workflow
- ollama-ipex-llm tarball exceeded file size
- ollama-ipex-llm unpacked directory exceeded file size
- Miniforge install script exceeded file size

Solution was more convoluted than expected. Work has been documented in git-commit-struggles.md