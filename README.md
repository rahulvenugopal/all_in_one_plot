# all_in_one_plot
## A single plot which shows data distribution, data points, median (mean) and IQRs

![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/rt_dist_box_point.png)

---

This work is inspired by Cédric Scherer's work on TidyTuesday with palmer penguins dataset

![](https://raw.githubusercontent.com/Z3tt/TidyTuesday/master/plots/2020_31/2020_31_PalmerPenguins.png)

---

### Detailed walkthrough

1. Plot a thin boxplot
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/1_thinbox.png)

2. Plot $25^{th}$ quartile
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/2_q25.png)
3. Plot $75^{th}$ quartile
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/3_q75.png)
4. Add a color border at q25
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/4_border_at_q25.png)
5. Add a color border at q75
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/5_border_at_q75.png)
6. Adding point plots as vertical lines (like a barcode)
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/6_points_as_bars.png)
7. Plot KDE plot
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/7_kde.png)
8. Adding median onto the plot like a diamond
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/8_median.png)
9. Adding sample size
   ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/9_sample_size.png)
10. Changing color palette
    ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/10_color_palette_change.png)
11. Final theming and saving in particular dimensions
    ![](https://github.com/rahulvenugopal/all_in_one_plot/blob/main/plots/rt_dist_box_point.png)