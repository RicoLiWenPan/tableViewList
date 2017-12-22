# tableViewList
可拖动排序的table、
apple自带的tableview，cell拖动功能可点击范围较小，我写了一个整个cell可拖动的控件。
实现思路大概如下：

1.点击时获取用户触控范围，确定到具体cell。

2.利用apple自带截图方法伪造原来的cell。

3.cell跟随手指移动，（期间cell动画排序）。

4.手指离开屏幕，cell有数据元插入并reload，完成。
