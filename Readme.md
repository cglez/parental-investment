# Parental investment sexual conflict

## What is it?

This is an ecosystem model for the study of parental investment in sexual reproduction and focused primarily on the sexual conflict. In this model, a life form with two sexes reproduce and nurture offspring so to increase their chance of survival. The amount of time a parent is to spend on nurturing is determined by its genes. Each sex exhibits differentiated behaviour due to sex-limited genes. These traits are transmitted to the descendants and open to variation through mutation. By simulating certain ecological conditions and species characteristics one can see what parental investment strategies emerge in the long run based solely in the survival of the fittest.

This model is based on the NetLogo library model *Wolf-Sheep stride inheritance*, a predator-prey ecosystem with inheritance model.

## How it Works

At initialisation we start with a `max-population` number of specimens. The number is kept during the simulation with the oldest agents dying when new offspring is spawn as of overpopulation. Organisms start with sex and position chosen at random. Both sexes wander around looking for a suitable partner to mate with. When they reproduce the offspring inherits their genes perhaps altered by mutation.

The species has two sexes with different morphologies, but this is just a cosmetic distinction. Their appearance doesn't tell us much about which sex is which. We also refer to them as sex A and sex B. This is to avoid preconceptions about sexual behaviour. The differences in behaviour they may develop throughout a simulation depend exclusively on characteristics local to the agents and are emergent properties of the system. The first of these local aspects is a fundamental gap in the initial investment needed for reproduction. This encodes the difference in cost of gamete production in real species that practice anisogamy, where the female initial expenditure is larger due to the larger size of her sexual cells. This can be tweaked using the `egg-size` parameter. The other difference is the presence of sex-limited genes. In particular, time spent in parental care is encoded in different genes per sex, so they can develop behaviour independently and give rise to particular strategies. Apart from this, the two sexes do exactly the same.

The life cycle of the organisms encompasses tree distinct stages: egg, nymph and adult. Egg clusters are represented as white patches in the terrain. In the egg phase specimens stay in their patch and receive energy from the parents as long as they 'choose' to feed them. When `hatch-age` is reached eggs hatch and nymphs are free to leave. Nymphs look just like adult specimens just smaller. They can move but can't reproduce. When organisms come to `adult-age` they grow bigger and are ready to reproduce.

Reproduction takes place when two adults of opposite sex encounter each other. The only sexual selection mechanism implemented here is that of a minimum energy required for reproduction (`min-energy-reproduce`). When there are more than one suitable partners, one of them is chosen at random. When a couple reproduces, sex A specimen lays a `number-eggs` amount of eggs providing each one with an equal `egg-size` amount of initial energy. The amount of energy spent by sex B in reproduction, as of fertilisation of eggs, is considered negligible and not taken into account. Hence, when it comes to reproduction, energy spent on eggs is the only sex difference in the species.

Organisms embody two genes: `a-nurturing` and `b-nurturing`. The first one determines the nurturing time of sex A whereas the second determines the nurturing time of sex B. That is, the time they spend feeding offspring. These are sex-limited genes, i.e. genes that are present in both sexes but are expressed in only one sex and remain dormant in the other. Both sexes will show different behaviour in terms of rearing despite carrying the same genetic material.

At the time of mating genes are combined and passed down to the next generation. Combination happens thanks to a simple crossing system. Each gene inherits the parent A variant or the parent B variant with equal probability. This happens for all genes and for all children. Genes can also mutate at the time of copying via gene drift. That is, the value encoded in a gene can get slightly bigger or smaller to a certain limit given by the parameter `drift`. This way nurturing time becomes slightly longer or shorter from one generation to the next.

Once the eggs have been spawn and fecundated, parents start rearing the offspring. Parents stay with their eggs and periodically feed each one of them a certain amount of energy as long as determined by its genes. Each sex behaves differently according to the corresponding sex-limited gene.

In general, due to Darwinian pressure, both sexes will try to maximise time spent looking for new mates to further spread their genes. Genes telling organisms to do otherwise will tend to be less successful at transferring their genes to the next generation, will fail at populating the environment and finally will tend to vanish in time.

Spending time caring for the offspring increases their chances of reproduction in the future and therefore so does gene transmission in general. There exists a trade off between seeking out other mates and rearing children. Furthermore, if your partner takes care of the offspring, you are pretty confident they will do well despite what you do. In this situation it is profitable, in terms of gene survival, to dessert your mate and try to spread your genes even more looking for a new partner. This is precisely the sexual conflict in parental investment. The most adaptive nurturing time for one sex depends on the time spent by the other so that they evolve in co-adaptation. In the model, certain combinations of parental investment strategies by the two sexes will evolve and stabilise in the population by mere survival of those who reproduce more efficiently.

## How to Use it

### Parameters

* `max-population`: The maximum overall population above of which the oldest specimens start dying
* `max-energy`: The maximum amount of energy any specimen can have
* `min-energy-reproduce`: The minimum amount of energy an organism needs to reproduce
* `drift`: The largest variation a gene can drift at copying as mutation
* `hatch-age`: The time it takes to an specimen to hatch from its egg and leave
* `egg-size`: The amount of energy an specimen is given at conception
* `number-eggs`: The number of new specimens created in reproduction
* `nurturing-energy`: The amount of energy spent per child periodically in rearing

### Setting up the Environment

Increasing `max-population` will also increase the chances of finding a partner. This could affect parental investment strategies by reducing the cost of finding a new mate. When the number is very small though, gene population can become sparse at initialization and the simulation not very representative.

`min-energy-reproduce` is the only sex selection mechanism in this model. Decreasing the minimum energy needed to reproduce has the effect of making the species more 'promiscuous'. This has an impact on parental care strategies and tends to make the parents less careful with children.

With a longer `drift` genes explore the possible values quicker and can scape local optima easier. This also has the effect of making the overall behaviour more erratic and the system less stable. The other way round, decreasing it makes the system less prone to change.

At initialization, gene values are spread from 0 to `hatch-age`. A larger value for this setting expands the gene space for exploration. It also reduces the nymph phase time leading sooner to adult age.

When sex A spawns eggs it spends an `egg-size` amount of energy multiplied by `number-eggs` number of eggs. This is the only difference between the two sexes at the time of mating and it is considered constituent of the species being simulated. By increasing or decreasing the egg size one widens or narrows the fundamental difference between sexes. According to this value the two sexes start from two different positions when they start exploring the adaptive landscape and this normally affects the outcome of the system when it stabilises. In other terms, a very big egg makes reproduction dangerous to sex A because it can drop its energy very quickly. With such a size one expects to see sex A specimens dying quicker.

The number of eggs spawn every time the species reproduce is determined by `number-eggs`. Changing it has several consequences. In the first place it has a multiplicative effect on the mating expenses of sex A, so one has to keep in mind what has been said before regarding energy consumption with `egg-size`. Secondly and more important, it changes the probability of a gene being passed down to the next generation. If only one egg is spawn every time the species reproduce, the parent can only expect to see a single gene of his in the next generation with 1/2 chance because this is the chance his gene will be taken instead of the other's at combining. With more eggs, the likelihood of a gene surviving is bigger. Security at having one's genes transmitted makes it more valuable to increase the chances of offspring survival by rearing rather than trying to spread more genes out by reproducing with new mates.

When a parent is nurturing it feeds periodically a `nurturing-energy` amount of energy to each child. Increasing this amount also increases the chances of offspring reproducing earlier in the future and consequently increases gene transmission efficiency (if not cancelled out by a small `min-energy-reproduce`). At the same time, a very high value can drain the energy of parents very quickly making rearing children a risky business.

## Reading Statistics

**population** plot simply shows the evolution of populations by sex over time. It also shows how many egg nests are in the territory and how many specimens are nurturing.

**parental investment** plot will show the total nurturing time spent by all specimens of a sex over time. It will highlight the difference in parental investment between the two sexes due to the behaviour dictated by their nurturing genes. Note that the initial mating expenses, that of spawning the eggs by sex A, is not shown in this plot.

**a-nurturing** and **b-nurturing** histograms will show how the population distribution of the different nurturing genes is changing. In the long run the most successful genes will become apparent and the stable strategies will consolidate showing groups of genes around certain values. If more than one parental care strategy can live together, different groups of genes will gather around different attractors. The red vertical line points out the `hatch-age`. A gene with this value makes its host fully committed to rearing, i.e. it will stay and care for the eggs for the whole time the they are in the nest. Nurturing times beyond this limit can be considered wasteful because it means time spent doing nothing with no benefit for the offspring. The yellow line indicates the mean nurturing time and helps visualising the genetic drift direction and the position from no parental care at all to full-childhood care.

## Things to Try

These are some things to try in order to simulate some species in some ecological environments:

* What do you see with the default settings? Do both sexes take the same strategy every time you run the model?
* Change the number of eggs to 1. What strategies do you see now?
* What about a number of eggs greater than 2?
* Now try adjusting the egg size. What does it happen to the different strategies when the egg size is very low? How do you explain it? Also, how does a very large egg size affect sex A?
* Try changing the nurturing energy and observe how this alters the gene populations in the long run. Check the extreme cases with very small and very large values. What consequences does this have on population when the value is relatively high?
* Try adjusting the different parameters. Can you find any set of values that simulate the following parental investment strategies: mate desertion, no parental care and cooperation?
* In which circumstances can more than one strategy live together?

Understanding the model. Try to explain the following strange phenomena you can come across in some simulations:

* How do you explain when genes take values beyond the hatch age?
* Think of the crossing system implemented in this model. How do you interpret when an apparently extinct gene variant reappears briefly like a glitch in histograms?

### Evolutionarily Stable Strategies

An evolutionarily stable strategy (or simply ESS) "is a strategy which, if adopted by a population in a given environment, cannot be invaded by any alternative strategy that is initially rare ... It is a Nash equilibrium that is 'evolutionarily' stable: once it is fixed in a population, natural selection alone is sufficient to prevent alternative (mutant) strategies from invading successfully." (From [Wikipedia](https://en.wikipedia.org/wiki/Evolutionarily_stable_strategy))

In parental investment, as well as in other fields in evolutionary biology, these strategies are usually found analytically using game theory applied to the possible strategies the sexes can 'choose'. Instead of working analytically try to use the `invasion` function to simulate one of those invading strategies. Its signature is the following:

`invasion n $a-nurturing $b-nurturing`

Where `n` is the number of specimens to be added into the simulation, `$a-nurturing` and `$b-nurturing` are the values of the corresponding genes. Sex and location is chosen randomly.

Using the observer input with this function you can simulate an invasion with the desired characteristics and check how resilient the current strategies are to the invading one. Does the system stay stable and new specimens tend to align to the existing attractors or do they drive previous organisms to extinction? How many invading specimens are needed in order to override the existing strategies?

## Extending the Model

This is a basic model of parental investment focused on sexual conflict and can only simulate a limited number of ecological environments. Some possible extensions are the following:

* Adding more genes. The majority of the species characteristics in this model are controlled by parameters but could be introduced into the simulation as new genes. In real ecosystems some of these characteristics play a role in the evolution of parental investment strategies. For example, a female could 'choose' to change the size of the eggs or its number as defence against exploitation by the male. We could then add genes for `egg-size` and `number-eggs` and allow them to mutate and evolve.
* Changing the inheritance model. As we have explained before, the gene combination mechanism implemented here simply takes one of the parents' genes with equal probability. Other systems are possible, perhaps more realistic. For example one could think of a crossing system where values are 'cut' through bit operations on the values and then assembled again.
* Eggs are perfectly safe when no parent is keeping them. We could make offspring vulnerable by, say, removing energy progressively when they aren't getting any parental care.
* Fecundation here is localised. Many species use other means of dissemination of their gametes. Thinking of fish, only eggs are spawn in a well defined place, sperms instead are released in water and fecundation happens thanks to diffusion. Implementing fecundation by diffusion could help to investigate the parental investment strategies derived from this type of fecundation.
* Rearing in this model happens where the eggs are spawn. Many species use different parental care systems. For example mothers in mammal species, among other life forms, carry their progeny inside them. Males provide care by other means, if they do at all for this matter. Try changing the mobility of children in order to explore the parental investment strategies derived from it.

This model could serve as a start point to build other models that study the other conflicts in parental investment: the parent-offspring conflict and the sibling conflict.

## Related Models

Wolf Sheep Stride Inheritance

## How to Cite

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* González, C. (2018). NetLogo Parental Investment Sexual Conflict model.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## Copyright and License

Copyright 2018 César González.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
