library(shiny)
library(ggplot2)

shinyServer(
    function(input, output) {
        output$plot1 <- renderPlot({
            input$button1
            waterfall1 <- df_waterfall(input$labour, input$indirect, input$price1, input$material1, input$direct1,
                        input$num.operators1, input$ct1, input$duration1, input$produced1, input$planned1, 
                        input$downtime1, input$NG1)
            plot_waterfall(waterfall1)
        })
        output$results <- renderTable({
            calc_results(input$labour, input$indirect, input$price1, input$material1, input$direct1,
                         input$num.operators1, input$ct1, input$duration1, input$produced1, input$planned1, 
                         input$downtime1, input$NG1)
        })
    }
)

df_waterfall <- function(labour, indirect, price, material, direct, num.operators, ct, duration, produced, planned, 
                         downtime, NG) {
    labour.min = labour / 60
    indirect.min = indirect / 60
    ideal.time = (produced*ct) / 60
    ideal.time.cost = ((produced-NG)*ct) / 60
    production.time = duration - planned - downtime
    prorate = (duration / (duration - planned))*labour.min*num.operators
    
    # Calculate revenue waterfall numbers
    revenue = price*(produced - NG)
    revenue = round(revenue, 2)
    ideal.cost = -1 * (material*(produced-NG) + direct*(produced-NG) + ideal.time.cost*(prorate + indirect.min))
    ideal.cost = round(ideal.cost, 2)
    downtime.loss = -1 * downtime*(prorate + indirect.min)
    downtime.loss = round(downtime.loss, 2)
    performance.loss = -1 * (production.time - ideal.time)*(prorate + indirect.min)
    performance.loss = round(performance.loss, 2)
    quality.loss = -1 * (material*NG + direct*NG + ((NG*ct)/60)*(prorate + indirect.min)) 
    quality.loss = round(quality.loss, 2)
    net = revenue + ideal.cost + downtime.loss + performance.loss + quality.loss
    net = round(net, 2)
    
    # Make Dataframe for ggplot
    waterfall <- data.frame(Categories = c("Revenue", "Expected Cost", "Downtime Losses", "Performance Losses", 
                                           "Quality Losses", "Net Profit"), amount = c(revenue, ideal.cost, 
                                                                                        downtime.loss, performance.loss,
                                                                                        quality.loss, net))
    waterfall$Categories <- factor(waterfall$Categories, levels = waterfall$Categories)
    waterfall$id <- seq_along(waterfall$amount)
    waterfall$type <- ifelse(waterfall$amount > 0, "Gain", "Loss")
    waterfall[waterfall$Categories %in% c("Revenue"), "type"] <- "Revenue"
    waterfall[waterfall$Categories %in% c("Net Profit"), "type"] <- "Profit"
    waterfall$end <- cumsum(waterfall$amount)
    waterfall$end <- c(head(waterfall$end, -1), 0)
    waterfall$start <- c(0, head(waterfall$end, -1))
    waterfall <- waterfall[, c(3, 1, 4, 6, 5, 2)]
    
    return(waterfall)
}

plot_waterfall <- function(waterfall) {
    waterfall$type <- factor(waterfall$type, levels = c("Loss", "Gain", "Revenue", "Profit"))
    strwr <- function(str) gsub(" ", "\n", str)
    p1 <- ggplot(waterfall, aes(fill = type)) + geom_rect(aes(x = Categories, xmin = id - 0.45, xmax = id + 0.45, 
                                                              ymin = end, ymax = start)) + 
        scale_y_continuous("") + scale_x_discrete("", breaks = levels(waterfall$Categories), 
                                                                       labels = strwr(levels(waterfall$Categories))) + 
        geom_text(aes(x=Categories, y=end, label=amount), size = 5) + theme(axis.text=element_text(size=13), 
                                                                            legend.position = "none")
    
    p1
}

calc_results <- function(labour, indirect, price, material, direct, num.operators, ct, duration, produced, planned, 
                         downtime, NG) {
    labour.min = labour / 60
    indirect.min = indirect / 60
    ideal.time = (produced*ct) / 60
    ideal.time.cost = ((produced-NG)*ct) / 60
    production.time = duration - planned - downtime
    prorate = (duration / (duration - planned))*labour.min*num.operators
    
    # Calculate numbers
    revenue = price*produced
    revenue = round(revenue, 2)
    ideal.cost = -1 * (material*(produced-NG) + direct*(produced-NG) + ideal.time.cost*(prorate + indirect.min))
    ideal.cost = round(ideal.cost, 2)
    downtime.loss = -1 * downtime*(prorate + indirect.min)
    downtime.loss = round(downtime.loss, 2)
    performance.loss = -1 * (production.time - ideal.time)*(prorate + indirect.min)
    performance.loss = round(performance.loss, 2)
    quality.loss = -1 * (material*NG + direct*NG + ((NG*ct)/60)*(prorate + indirect.min)) 
    quality.loss = round(quality.loss, 2)
    net = revenue + ideal.cost + downtime.loss + performance.loss + quality.loss
    net = round(net, 2)
    expected = revenue + ideal.cost
    loss.total = downtime.loss + performance.loss + quality.loss
    differences = net - expected 
    
    # Create table df
    results <- data.frame(Result = c("Revenue", "Expected Cost", "Expected Profit", "Additional Costs", 
                                           "Actual Profits", "Difference from Expected Profit"), 
                            Values = c(revenue, ideal.cost, expected, loss.total, net, differences))
    results$Percent.of.Revenue <- abs((results$Values / revenue)*100)
    
    return(results)
}