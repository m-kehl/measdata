f_plot_empty <- function(){
  ## function to create empty plot as placeholder in the Shinyapp
  #  -> the title indicates what the user should do next
  plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
}