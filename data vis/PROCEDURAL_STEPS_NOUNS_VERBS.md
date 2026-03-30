# MONTE CARLO INTEGRATION - PROCEDURAL STEPS USING NOUNS & VERBS

## STEP 1: GENERATE AND CREATE RANDOM COORDINATES

**Nouns Used**: coordinates, points, bounds, sample size, x-axis, y-axis, region, rectangle, sampling

**Verbs Used**: generate, create, random, runif (uniform random sampling)

### Procedural Steps:

1. **Create** a sampling region bounds specifying:
   - x-axis minimum and maximum
   - y-axis minimum and maximum

2. **Generate** random points within the bounds:
   - Use the `runif()` function to sample x-coordinates uniformly
   - Use the `runif()` function to sample y-coordinates uniformly
   - Create a total number equal to the sample size

3. **Create** a tibble (rectangle of data) with:
   - Column 1: x-axis coordinates
   - Column 2: y-axis coordinates

4. **Return** the data structure containing all generated points

---

## STEP 2: EVALUATE, COMPARE, AND FLAG CLASSIFICATION STATUS

**Nouns Used**: function value, curve, classification, flag, point location, above/below status, indicator variable

**Verbs Used**: evaluate, compare, flag, mutate, classify

### Procedural Steps:

1. **Evaluate** the function at each x-coordinate:
   - Calculate function value for every point's x position
   - Create a column with the curve's y-value

2. **Compare** each point's location to the curve:
   - Take the point's y-coordinate
   - Compare it to the function value at that x

3. **Classify** each point's position:
   - Identify if y (point) > function value (curve) = above
   - Identify if y (point) ≤ function value (curve) = below

4. **Mutate** the data to add an indicator variable:
   - Create a boolean flag column: `is_above_function`
   - Set TRUE for points above the curve
   - Set FALSE for points on or below the curve

5. **Return** the classified data with above/below status for each point

---

## STEP 3: CALCULATE THE AREA ESTIMATE

**Nouns Used**: area, rectangle area, proportion, ratio, points below, total points, integration estimate

**Verbs Used**: calculate, multiply, estimate, count

### Procedural Steps:

1. **Calculate** the rectangle area:
   - Take (x-maximum - x-minimum)
   - Multiply by (y-maximum - y-minimum)
   - Store as rectangle area

2. **Count** points classified as below:
   - Sum all FALSE values in the indicator variable
   - This equals the points below the curve

3. **Count** total points:
   - Determine total number of points generated

4. **Calculate** the proportion:
   - Divide: points below / total points
   - This is the ratio of points under the curve

5. **Multiply** to estimate the area:
   - Multiply rectangle area × proportion
   - Result = integration estimate

6. **Return** the numerical integration estimate

---

## STEP 4: VISUALIZE WITH REUSABLE PLOT TEMPLATE

**Nouns Used**: plot, scatter points, curve line, ggplot layers, color categories, titles, subtitle, sample size

**Verbs Used**: plot, visualize, display, layer, color-code, label, title, format, theme

### Procedural Steps:

1. **Create** a smooth curve for visualization:
   - Generate x-values across the domain
   - Evaluate the function at each x
   - Create a data structure with curve coordinates

2. **Layer** the first scatter of points:
   - **Plot** points classified as above the curve
   - **Color-code** them one color (red)
   - **Display** with semi-transparent alpha

3. **Layer** the second scatter of points:
   - **Plot** points classified as below the curve
   - **Color-code** them a different color (blue)
   - **Display** with semi-transparent alpha

4. **Layer** the function curve:
   - **Plot** the smooth curve line
   - **Color** it distinctly (black)
   - **Format** with appropriate line width

5. **Add** titles and labels to the plot:
   - **Title** the plot with function description
   - **Create a subtitle** displaying sample size
   - **Label** the axes (x, y)

6. **Format** aesthetic elements:
   - **Apply** a minimal theme
   - **Adjust** text sizes for readability
   - **Remove** unnecessary gridlines

7. **Return** a ggplot object that can be reused

---

## STEP 5: LOOP THROUGH AND EXECUTE ANALYSIS AT MULTIPLE RESOLUTIONS

**Nouns Used**: sample size, resolution, parameters, function, bounds, sample sizes vector, loop, results, plots

**Verbs Used**: define, loop, generate, classify, calculate, store, create, accumulate

### Procedural Steps:

1. **Define** the function to integrate

2. **Define** the bounds:
   - x minimum and maximum
   - y minimum and maximum

3. **Define** a vector of sample sizes:
   - Example: [100, 250, 1000, 5000]
   - These represent four resolutions

4. **Loop** through each sample size sequentially:
   
   a. **Generate** coordinates at current resolution
   
   b. **Classify** points (flag above/below)
   
   c. **Calculate** area estimate at this resolution
   
   d. **Calculate** percentage of points below
   
   e. **Store** numerical results in a results tibble:
      - Sample size value
      - Estimated area value
      - Percent below value
   
   f. **Create** a plot for this resolution
   
   g. **Store** plot in a plots list/collection

5. **Accumulate** all results and plots through iterations

---

## STEP 6: DISPLAY AND ARRANGE FINAL OUTPUTS

**Nouns Used**: small multiples, grid, table, estimates, visualization, results summary, numerical summary, comparison

**Verbs Used**: arrange, grid, print, display, bind, summarize

### Procedural Steps:

1. **Print** a results table displaying:
   - Column 1: Sample sizes
   - Column 2: Estimated areas
   - Column 3: Percent below for each resolution

2. **Format** the numerical summary:
   - **Display** in readable table format
   - **Round** values to appropriate decimals
   - **Label** each column clearly

3. **Display** the true analytical solution:
   - **Print** the comparison value
   - **Show** the analytical formula used

4. **Arrange** all 4 plots in a grid:
   - **Grid** them as 2 rows × 2 columns
   - This creates the small multiples visualization

5. **Bind** plots together spatially:
   - Combine all 4 plot objects
   - Create unified visual display

6. **Print** the final small multiples:
   - Display complete 2×2 grid
   - Show all resolutions simultaneously

7. **Display** an overall title:
   - Label the entire grid appropriately

---

## COMPLETE WORKFLOW SUMMARY

Using all nouns and verbs from the plan:

1. **GENERATE** → Create random **coordinates** within **bounds**
2. **EVALUATE** → Calculate **function values** at each point
3. **COMPARE** → Classify points as above/**below** the **curve**
4. **FLAG** → Mutate data with **indicator variable**
5. **COUNT** → Tally **points below** and **total points**
6. **CALCULATE** → Multiply **rectangle area** × **proportion** = **estimate**
7. **PLOT** → Visualize **scatter points** and **curve line** with **color-code**
8. **LAYER** → Create **ggplot layers** with appropriate **themes**
9. **LOOP** → Execute pipeline at each **sample size** in **resolutions vector**
10. **STORE** → **Accumulate** **plots** and **results** from each iteration
11. **ARRANGE** → Create **small multiples** **grid** of 4 **visualizations**
12. **SUMMARIZE** → **Display** **numerical summary** table and **comparison** values
13. **PRINT** → Present final 2×2 **grid** with all **estimates**

