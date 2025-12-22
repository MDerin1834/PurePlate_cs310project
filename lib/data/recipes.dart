import 'package:pure_plate/models/recipe.dart';

// Data for demo purposes
// From https://www.themealdb.com/
// Cooking time and calories fields are randomly generated
const List<Recipe> recipes = [
  Recipe(
    name: 'Pizza Express Margherita',
    imageURL:
        'https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg/small',
    calories: 1170,
    protein: 12,
    cookingTime: 11,
    instructions: '''1 Preheat the oven to 230°C.

2 Add the sugar and crumble the fresh yeast into warm water.

3 Allow the mixture to stand for 10 – 15 minutes in a warm place (we find a windowsill on a sunny day works best) until froth develops on the surface.

4 Sift the flour and salt into a large mixing bowl, make a well in the middle and pour in the yeast mixture and olive oil.

5 Lightly flour your hands, and slowly mix the ingredients together until they bind.

6 Generously dust your surface with flour.

7 Throw down the dough and begin kneading for 10 minutes until smooth, silky and soft.

8 Place in a lightly oiled, non-stick baking tray (we use a round one, but any shape will do!)

9 Spread the passata on top making sure you go to the edge.

10 Evenly place the mozzarella (or other cheese) on top, season with the oregano and black pepper, then drizzle with a little olive oil.

11 Cook in the oven for 10 – 12 minutes until the cheese slightly colours.

12 When ready, place the basil leaf on top and tuck in!''',
    ingredients: [
      'Water',
      'Sugar',
      'Yeast',
      'Plain Flour',
      'Salt',
      'Olive Oil',
      'Passata',
      'Mozzarella',
      'Oregano',
      'Basil',
      'Black Pepper',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: true,
  ),

  Recipe(
    name: 'Lamb and Lemon Souvlaki',
    imageURL:
        'https://www.themealdb.com/images/media/meals/rjhf741585564676.jpg/small',
    calories: 1163,
    protein: 35,
    cookingTime: 38,
    instructions:
        '''Pound the garlic with sea salt in a pestle and mortar (or use a small food processor), until the garlic forms a paste. Whisk together the oil, lemon juice, zest, dill and garlic. Mix in the lamb and combine well. Cover and marinate for at least 2 hrs or overnight in the fridge. If you’re going to use bamboo skewers, soak them in cold water.

If you’ve prepared the lamb the previous day, take it out of the fridge 30 mins before cooking. Thread the meat onto the soaked or metal skewers. Heat the grill to high or have a hot griddle pan or barbecue ready. Cook the skewers for 2-3 mins on each side, basting with the remaining marinade. Heat the pitta or flatbreads briefly, then stuff with the souvlaki. Add Greek salad (see 'Goes well with', right) and Tzatziki (below), if you like.''',
    ingredients: [
      'Garlic',
      'Sea Salt',
      'Olive Oil',
      'Lemon',
      'Dill',
      'Lamb Leg',
      'Pita Bread',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: false,
  ),

  Recipe(
    name: 'Red curry chicken kebabs',
    imageURL:
        'https://www.themealdb.com/images/media/meals/prjve31763486864.jpg/small',
    calories: 1342,
    protein: 30,
    cookingTime: 56,
    instructions: '''step 1
Fire up the barbecue or heat a griddle pan to high. Tip chicken, curry paste and coconut milk into a bowl, then mix well until the chicken is evenly coated. Thread vegetables and chicken onto skewers. Cook the skewers on the barbecue or griddle for 5-8 mins, turning every so often, until the chicken is cooked through and charred. Serve with herby rice, salad and a lime half to squeeze over.''',
    ingredients: [
      'Chicken Breasts',
      'Thai Red Curry Paste',
      'Coconut Milk',
      'Red Pepper',
      'Courgettes',
      'Red Onions',
      'Lime',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: false,
  ),

  Recipe(
    name: 'Sticky Chicken',
    imageURL:
        'https://www.themealdb.com/images/media/meals/cj56fs1762340001.jpg/small',
    calories: 408,
    protein: 25,
    cookingTime: 20,
    instructions: '''step 1
Make 3 slashes on each of the drumsticks. Mix together the soy, honey, oil, tomato purée and mustard. Pour this mixture over the chicken and coat thoroughly. Leave to marinate for 30 mins at room temperature or overnight in the fridge. Heat oven to 200C/fan 180C/gas 6.

step 2
Tip the chicken into a shallow roasting tray and cook for 35 mins, turning occasionally, until the chicken is tender and glistening with the marinade.''',
    ingredients: [
      'Chicken drumsticks',
      'Soy Sauce',
      'Honey',
      'Olive Oil',
      'Tomato Puree',
      'Dijon Mustard',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: false,
  ),

  Recipe(
    name: 'Summer Pudding',
    imageURL:
        'https://www.themealdb.com/images/media/meals/rsqwus1511640214.jpg/small',
    calories: 1232,
    protein: 5,
    cookingTime: 40,
    instructions:
        '''Bring out the juices: Wash fruit and gently dry on kitchen paper – keep strawberries separate. Put sugar and 3 tbsp water into a large pan. Gently heat until sugar dissolves – stir a few times. Bring to a boil for 1 min, then tip in the fruit (not strawberries). Cook for 3 mins over a low heat, stirring 2-3 times. The fruit will be softened, mostly intact and surrounded by dark red juice. Put a sieve over a bowl and tip in the fruit and juice.
Line the bowl with cling film and prepare the bread: Line the 1.25-litre basin with cling film as this will help you to turn out the pudding. Overlap two pieces of cling film in the middle of the bowl as it’s easier than trying to get one sheet to stick to all of the curves. Let the edges overhang by about 15cm. Cut the crusts off the bread. Cut 4 pieces of bread in half, a little on an angle, to give 2 lopsided rectangles per piece. Cut 2 slices into 4 triangles each and leave the final piece whole.
Build the pud: Dip the whole piece of bread into the juice for a few secs just to coat. Push this into the bottom of the basin. Now dip the wonky rectangular pieces one at a time and press around the basin’s sides so that they fit together neatly, alternately placing wide and narrow ends up. If you can’t quite fit the last piece of bread in it doesn’t matter, just trim into a triangle, dip in juice and slot in. Now spoon in the softened fruit, adding the strawberries here and there as you go.
Let flavours mingle then serve: Dip the bread triangles in juice and place on top – trim off overhang with scissors. Keep leftover juice for later. Bring cling film up and loosely seal. Put a side plate on top and weight down with cans. Chill for 6 hrs or overnight. To serve, open out cling film then put a serving plate upside-down on top and flip over. serve with leftover juice, any extra berries and cream.''',
    ingredients: [
      'Strawberries',
      'Blackberries',
      'Redcurrants',
      'Raspberries',
      'Caster Sugar',
      'Bread',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: false,
  ),

  Recipe(
    name: 'Mushroom & Chestnut Rotolo',
    imageURL:
        'https://www.themealdb.com/images/media/meals/ssyqwr1511451678.jpg/small',
    calories: 663,
    protein: 15,
    cookingTime: 43,
    instructions:
        '''Soak the dried mushrooms in 350ml boiling water and set aside until needed. Blitz ¾ of the chestnuts with 150ml water until creamy. Roughly chop the remaining chestnuts.
Heat 2 tbsp olive oil in a large non-stick frying pan. Fry the shallots with a pinch of salt until softened, then add the garlic, chopped chestnuts and rosemary, and fry for 2 mins more. Add the wild mushrooms, 2 tbsp oil and some seasoning. Cook for 3 mins until they begin to soften. Drain and roughly chop the dried mushrooms (reserve the soaking liquid), then add those too, along with the soy sauce, and fry for 2 mins more.
Whisk the wine, reserved mushroom liquid and chestnut cream together to create a sauce. Season, then add half to the mushroom mixture in the pan and cook for 1 min until the sauce becomes glossy. Remove and discard the rosemary sprigs, then set the mixture aside.
Heat oven to 180C/160C fan/gas 4. Bring a large pan of salted water to the boil and get a large bowl of ice water ready. Drop the lasagne sheets into the boiling water for 2 mins or until pliable and a little cooked, then immediately plunge them into the cold water. Using your fingers, carefully separate the sheets and transfer to a clean tea towel. Spread a good spoonful of the sauce on the bottom two thirds of each sheet, then, rolling away from yourself, roll up the shorter ends. Cut each roll in half, then position the rolls of pasta cut-side up in a pie dish that you are happy to serve from at the table. If you have any mushroom sauce remaining after you’ve rolled up all the sheets, simply push it into some of the exposed rolls of pasta.
Pour the rest of the sauce over the top of the pasta, then bake for 10 mins or until the pasta no longer has any resistance when tested with a skewer.
Meanwhile, put the breadcrumbs, the last 2 tbsp olive oil, sage leaves and some seasoning in a bowl, and toss everything together. Scatter the rotolo with the crumbs and sage, then bake for another 10 mins, until the top is golden and the sage leaves are crispy. Leave to cool for 10 mins to allow the pasta to absorb the sauce, then drizzle with a little truffle oil, if you like, before taking your dish to the table.''',
    ingredients: [
      'Mushrooms',
      'Chestnuts',
      'Challots',
      'Garlic',
      'Rosemary',
      'Wild Mushrooms',
      'Soy Sauce',
      'White Wine',
      'Lasagne Sheets',
      'Breadcrumbs',
      'Sage',
      'Truffle Oil',
    ],
    isVegetarian: true,
    isLactoseFree: false,
    isFavourite: false,
  ),

  Recipe(
    name: 'Pancakes',
    imageURL:
        'https://www.themealdb.com/images/media/meals/rwuyqx1511383174.jpg/small',
    calories: 1110,
    protein: 8,
    cookingTime: 35,
    instructions:
        '''Put the flour, eggs, milk, 1 tbsp oil and a pinch of salt into a bowl or large jug, then whisk to a smooth batter. Set aside for 30 mins to rest if you have time, or start cooking straight away.
Set a medium frying pan or crêpe pan over a medium heat and carefully wipe it with some oiled kitchen paper. When hot, cook your pancakes for 1 min on each side until golden, keeping them warm in a low oven as you go.
Serve with lemon wedges and sugar, or your favourite filling. Once cold, you can layer the pancakes between baking parchment, then wrap in cling film and freeze for up to 2 months.''',
    ingredients: [
      'Flour',
      'Eggs',
      'Milk',
      'Sunflower Oil',
      'Sugar',
      'Raspberries',
      'Blueberries',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: false,
  ),
  Recipe(
    name: 'French Omelette',
    imageURL:
        'https://www.themealdb.com/images/media/meals/yvpuuy1511797244.jpg/small',
    calories: 194,
    protein: 24,
    cookingTime: 46,
    instructions:
        '''Get everything ready. Warm a 20cm (measured across the top) non-stick frying pan on a medium heat. Crack the eggs into a bowl and beat them with a fork so they break up and mix, but not as completely as you would for scrambled egg. With the heat on medium-hot, drop one knob of butter into the pan. It should bubble and sizzle, but not brown. Season the eggs with the Parmesan and a little salt and pepper, and pour into the pan.
Let the eggs bubble slightly for a couple of seconds, then take a wooden fork or spatula and gently draw the mixture in from the sides of the pan a few times, so it gathers in folds in the centre. Leave for a few seconds, then stir again to lightly combine uncooked egg with cooked. Leave briefly again, and when partly cooked, stir a bit faster, stopping while there’s some barely cooked egg left. With the pan flat on the heat, shake it back and forth a few times to settle the mixture. It should slide easily in the pan and look soft and moist on top. A quick burst of heat will brown the underside.
Grip the handle underneath. Tilt the pan down away from you and let the omelette fall to the edge. Fold the side nearest to you over by a third with your fork, and keep it rolling over, so the omelette tips onto a plate – or fold it in half, if that’s easier. For a neat finish, cover the omelette with a piece of kitchen paper and plump it up a bit with your fingers. Rub the other knob of butter over to glaze. Serve immediately.''',
    ingredients: [
      'Eggs',
      'Butter',
      'Parmesan',
      'Tarragon Leaves',
      'Parsley',
      'Chives',
      'Gruyère',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: false,
  ),

  Recipe(
    name: 'Imam bayildi',
    imageURL:
        'https://www.themealdb.com/images/media/meals/ampz9v1763787134.jpg/small',
    calories: 1287,
    protein: 18,
    cookingTime: 8,
    instructions: '''step 1
Heat oven to 190C/170C fan/gas 5. Halve the aubergines lengthways and score the flesh side deeply, brush with a good layer of olive oil and put on a baking sheet. Roast for 20 mins or until the flesh is soft enough to scoop out.

step 2
Fry the onion in a little oil until soft, add the garlic and cinnamon and fry for 1 min. Once the aubergines are cool enough to handle, scoop out the centres. Roughly chop the flesh and add it to the onions. Halve the tomatoes, scoop the seeds and juice into a sieve set over a bowl, then chop the flesh. Add the chopped tomatoes to the pan and cook everything for 10 mins until nice and soft. Add a little more oil if you need to. Stir in the parsley, leaving a little for scattering at the end.

step 3
Lay the aubergine halves in a baking dish and divide the tomato mixture between them. Pour over the juice from the tomatoes, drizzle with more olive oil and bake for 30 mins until the aubergines have collapsed.

step 4
Meanwhile, mix the tzatziki ingredients together and put in a small serving bowl.

step 5
Season the lamb with salt, black pepper and a pinch of paprika. Griddle, grill or barbecue for 3 mins on each side or until the fat is nicely browned, then put in a serving dish and squeeze over the lemon halves. Scatter the aubergines with parsley, then serve with the lamb and tzatziki.''',
    ingredients: [
      'Aubergine',
      'Olive Oil',
      'Onion',
      'Garlic',
      'Cinnamon',
      'Tomato',
      'Parsley',
      'Lamb Loin Chops',
      'Paprika',
      'Lemon',
      'Greek Yogurt',
      'Cucumber',
      'Mint',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: true,
  ),

  Recipe(
    name: 'Slow-roast lamb',
    imageURL:
        'https://www.themealdb.com/images/media/meals/gr4lo51763791826.jpg/small',
    calories: 428,
    protein: 38,
    cookingTime: 21,
    instructions: '''step 1
Put the lamb into a large food bag with all the juice and marinate overnight.

step 2
The next day, take the lamb out of the fridge 1 hr before you want to cook it. Heat oven to 220C/200C fan/gas 7. Take the lamb out of the marinade (reserve remaining marinade) and pat dry. Rub with half the oil and roast for 15-20 mins until browned. Remove lamb and reduce oven to 160C/140C fan/gas 3.

step 3
Mix the zests, remaining oil, honey, spices and garlic with plenty of seasoning. Lay a large sheet of baking parchment on a large sheet of foil. Sit the lamb leg on top, rub all over with the paste and pull up the sides of the foil. Drizzle marinade into base, and scrunch foil to seal.

step 4
Roast for 4 hrs, until very tender. Rest, still wrapped, for 30 mins. Unwrap and serve with juices.''',
    ingredients: [
      'Lamb Leg',
      'Lemon',
      'Olive Oil',
      'Clear Honey',
      'Cinnamon',
      'Fennel Seeds',
      'Ground Cumin',
      'Garlic',
    ],
    isVegetarian: false,
    isLactoseFree: false,
    isFavourite: false,
  ),
];
