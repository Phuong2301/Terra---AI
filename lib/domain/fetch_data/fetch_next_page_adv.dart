import 'fetching_data.dart';
import 'models/base_nextpage_model.dart';

class FetchingNextPageAdv<T> extends FetchingData<T> {
  Future<MBaseNextPage<T>?> fetch;
  FetchingNextPageAdv(this.fetch);

  int totalPage = 1;
  int currentPage = 0;

  @override
  initFetch() async {
    if (datas != null) return;
    if (isFetching) return;
    isFetching = true;
    final res = await getApiNextPage();
    if (res == null) return;
    isFetching = false;
    datas = res.datas;
    totalPage = res.totalPage;
  }

  fetchNextPage() async {
    if (currentPage > totalPage) return;
    if (isFetching) return;
    isFetching = true;
    final res = await getApiNextPage();
    if (res == null) return;
    isFetching = false;
    datas!.addAll(res.datas);
  }

  @override
  clear() {
    currentPage = 0;
    totalPage = 1;
    super.clear();
  }

  @override
  Future refresh() async {
    currentPage = 0;
    totalPage = 1;
    await initFetch();
  }

  bool get isNextPage => currentPage <= totalPage;

  Future<MBaseNextPage<T>?> getApiNextPage() async {
    return fetch;
  }
}
