library(randomForest)
library(caret)

# Get dataset
redW <- read.csv("./Data/winequality-red.csv", header = TRUE, sep = ";")
whiteW <- read.csv("./Data/winequality-white.csv", header = TRUE, sep = ";")

# Get model relate to wine type
set.seed(12345)
modelRedW <- randomForest(quality ~ ., data = redW, ntree = 150)
modelWhiteW <- randomForest(quality ~ ., data = whiteW, ntree = 150)

# Slider labels with measurements units
sliderLabel <- c("HTML(\"fixed.acidity - Fixed Acidity (total acidity, tartaric acid) - g/dm<sup>3</sup>\")",
"HTML(\"volatile.acidity - Volatile  Acidity (acetic acid, capable of evaporating at low temp.) - g/dm<sup>3</sup>\")",
"HTML(\"citric.acid - Citric Acid (preservative/conservative) - g/dm<sup>3</sup>\")",
"HTML(\"residual.sugar - Residual Sugar (level of sugar unfermented) - g/dm<sup>3</sup>\")",
"HTML(\"chlorides - Chloride (Sodium Chloride, maintains acid/base balance) - mg/dm<sup>3</sup>\")",
"HTML(\"free.sulfur.dioxide - Free Sulfur Dioxide (prevent oxidation) - mg/dm<sup>3</sup>\")",
"HTML(\"total.sulfur.dioxide - Total Sufur Dioxide (preservative) - mg/dm<sup>3</sup>\")",
"HTML(\"density - Density (informal notion of thickness) - g/dm<sup>3</sup>\")",
"pH (acid 0 to 6, 7 neutral, basic 8 to 14)",
"HTML(\"sulphates - Sulphates (additive) - g/dm<sup>3</sup>\")",
"alcohol - Alcohol - % of volume",
"Quality (0 very bad : 10 very excellent)")

###
### Verify red wine model accuracy
###
redWine <- redW

# Change quality variable in factor
redWine$quality <- as.factor(redWine$quality)

# Split original dataset in 80% for training and 20% for testing
set.seed(56789)
splitRW <- createDataPartition(y = redWine$quality, p = 0.8, list = FALSE)
wineRTrng <- redWine[splitRW, ]
wineRTest <- redWine[-splitRW, ]

# Get model for training dataset
modelredWine <- randomForest(quality ~ ., data = wineRTrng, ntree = 150)

# Get quality prediction using test dataset
predR <- predict(modelredWine, newdata = wineRTest)

# Get result
redRes <- table(predR, wineRTest$quality)

# Get accuracy in percentuage
redAccuracy <- round(sum(diag(redRes))/nrow(wineRTest), 3)*100

###
### Verify white wine model accuracy
###
whiteWine <- whiteW

# Change quality variable in factor
whiteWine$quality <- as.factor(whiteWine$quality)

# Split original dataset in 80% for training and 20% for testing
set.seed(56789)
splitWW <- createDataPartition(y = whiteWine$quality, p = 0.8, list = FALSE)
wineWTrng <- whiteWine[splitWW, ]
wineWTest <- whiteWine[-splitWW, ]

# Get model for training dataset
modelwhiteWine <- randomForest(quality ~ ., data = wineWTrng, ntree = 150)

# Get quality prediction using test dataset
predW <- predict(modelwhiteWine, newdata = wineWTest)

# Get result
whiteRes <- table(predW, wineWTest$quality)

# Get accuracy in percentuage
whiteAccuracy <- round(sum(diag(whiteRes))/nrow(wineWTest), 3)*100


