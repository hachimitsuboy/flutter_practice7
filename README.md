# combine_provider

複数のProviderを組み合わせ、使用する

## 自分用にメモ

ref.watch: プロバイダの値を取得した上で、その変化を監視する。値が変化すると、その値に依存するウィジェットやプロバイダの更新が行われる。
ref.listen: プロバイダの値を監視し、値が変化するたびに呼び出されるコールバック関数（画面遷移、ダイアログの表示など）を登録する。
ref.read: プロバイダの値を取得する（監視はしない）。クリックイベント等の発生時に、その時点での値を取得する場合に使用できる。
